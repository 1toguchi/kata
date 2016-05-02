      @parent_lessons = Lesson.repeats.where(teacher_id: current_user).where.not(student_id: nil)
      @requests = Request.to(current_user).pending
      @done_request = Request.to(current_user).done.first
      @booked_lessons = Lesson.booked.to(current_user).in_future
      @past_lesson = Lesson.booked.to(current_user).in_past.first
      @opened_lessons = Lesson.opened_by(current_user).in_future.order(lesson_datetime: :asc)
      @opened_repeat_lessons = Lesson.repeats.opened_by(current_user).order(youbi: :asc, start_time: :asc)
      @weekday = %w(日 月 火 水 木 金 土)
      lessons = Lesson.where.not(parent_id: 0).where(teacher_id: current_user.id).pluck(:student_id,:teacher_id).uniq
      pluck   = []
      lessons.each do |lesson|
        unless lesson[0].nil?
          pluck << lesson
        end
      end

      @s_t_date = []
      pluck.each do |s_id_t_id|
        lessons = Lesson.where.not(parent_id: 0).where(student_id: s_id_t_id[0], teacher_id: s_id_t_id[1])
        first_lesson_date = lessons.first.date.strftime("%Y-%m-%d")
        last_lesson_date  = lessons.last.date.strftime("%Y-%m-%d")

        next if Date.today < Date.parse(first_lesson_date)

        if Date.today < Date.parse(last_lesson_date)
          diff = (Date.today - Date.parse(first_lesson_date)).to_i
        else
          diff = (Date.parse(last_lesson_date) - Date.parse(first_lesson_date)).to_i
        end
        @date_arr = []
        @date_arr << Date.parse(first_lesson_date).strftime("%Y-%m-%d")
        1.upto(diff) do |n|
          @date_arr << (Date.parse(first_lesson_date) + n.day).strftime("%Y-%m-%d")
        end

        @s_t_date << [s_id_t_id[0], s_id_t_id[1], @date_arr]
      end

      custom_date_arr = []
      if @s_t_date.present? && params[:beginning].present? && params[:end].present?
        diff = (Date.parse(params[:end]) - Date.parse(params[:beginning])).to_i
        0.upto(diff) do |n|
          custom_date_arr << (Date.parse(params[:beginning]) + n.day).strftime("%Y-%m-%d")
        end
      else
        diff = (Date.today - Date.today.beginning_of_month).to_i
        0.upto(diff) do |n|
          custom_date_arr << (Date.today.beginning_of_month + n.day).strftime("%Y-%m-%d")
        end
      end

      @custom_s_t_date = []
      0.upto(@s_t_date.count - 1) do |i|
        if (@s_t_date[i][2] & custom_date_arr).present? #期間が重複しているか
          date_arr = @s_t_date[i][2] & custom_date_arr
          @custom_s_t_date << [@s_t_date[i][0], @s_t_date[i][1], date_arr]
        end
      end