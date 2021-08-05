class CategoriesController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to @category
    else
      render :new
    end
  end

  def update
    @category = Category.find(params[:id])

    if @category.update(category_params)
      redirect_to @category
    else
      render :edit
    end
  end

  def destroy
  end

  private
    def category_params
      params.require(:category).permit(:title, :description)
    end
end
