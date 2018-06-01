class ScreensController < ApplicationController
  def index
    @screens = Screen.all
  end

  def show
    @screen = Screen.includes(:rooms).find(params[:id])
    next_slide = compute_next_slide
    @next_slide_url = screen_path(@screen, slide: next_slide)
    @slide_length = 5

    render layout: "screen"
  end

  private

  def compute_next_slide
    params[:slide] ||= 1
    slide = Integer(params[:slide])
    slide + 1
  end
end
