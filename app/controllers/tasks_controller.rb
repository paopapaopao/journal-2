class TasksController < ApplicationController
  before_action :authenticate_user!

  def edit
    @category = Category.find(params[:category_id])
    @task = @category.tasks.find(params[:id])
  end

  def create
    @category = Category.find(params[:category_id])
    @task = @category.tasks.create(task_params)
    @task.update(user_id: current_user.id)

    redirect_to category_path(@category)
  end

  def update
    @category = Category.find(params[:category_id])
    @task = @category.tasks.find(params[:id])

    if @task.update(task_params)
      redirect_to category_path(@category)
    else
      render action: 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:category_id])
    @task = @category.tasks.find(params[:id])
    @task.destroy

    redirect_to category_path(@category)
  end

  private

  def task_params
    params.require(:task).permit(:description, :priority, :user_id)
  end
end
