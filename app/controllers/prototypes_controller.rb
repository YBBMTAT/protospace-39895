class PrototypesController < ApplicationController

  before_action :set_prototype, only: [:edit, :show, :update]
  before_action :move_to_new_user_session, except: [:index, :show]

  def index
    @prototypes = Prototype.all
  end
 
  def new
    @prototype = Prototype.new
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def create
    @prototype = Prototype.create(prototype_params)
    if @prototype.save
      redirect_to prototype_path(@prototype.id)
    else
      render :new
    end
  end

  def edit
    unless current_user == @prototype.user
      redirect_to root_path
    end
  end

  def update
    
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype.id)
    else
      render :edit
    end
  end
    

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept ,:image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def move_to_new_user_session
    unless user_signed_in? 
      redirect_to new_user_session_path
    end
  end


end
