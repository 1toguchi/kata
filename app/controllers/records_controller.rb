class RecordsController < ApplicationController
  before_filter :set_record, only: [:show, :edit, :update, :destroy]

  def index
    @records = Record.all.order(created_at: :desc)
  end

  def show
  end

  def new
   @record = Record.new
  end

  def edit
  end

  def create
    @record = Record.new(params_record)
    @record.save
    redirect_to records_path, notice: '保存しました'
  end

  def update
    @record.save
    redirect_to record_path(@record)
  end

  def destroy
    @record.destroy
    @record.save
    redirect_to root_path, notice: '削除しました'
  end

  def assoc
    @association = Record.all.order(created_at: :desc)
    @assoc = Record.all.order(created_at: :asc)
  end

  private
  def set_record
    @record = Record.find(params[:id])
  end

  def params_record
    params.require(:record).permit(:content, :memo, :text, :assoc, :later)
  end
end
