class ScreensController < ApplicationController
  def index
    @screens = Screen.all
  end

  def show
    params[:slide] ||= 0
    params[:slide] = Integer(params[:slide])

    @screen = Screen.includes(:rooms).find(params[:id])
    @slide = find_slide(params[:slide]) || default_slide
    @slide = @slide.decorate
    @next_slide_url = screen_path(@screen, slide: next_slide_index)
    @slide_length = 30

    render layout: "screen"
  end

  private

  def next_slide_index
    possible_next_slide_index = params[:slide] + 1

    if find_slide(possible_next_slide_index)
      possible_next_slide_index
    else
      0
    end
  end

  def find_slide(index)
    @screen.playlist.presence &&
      @screen.playlist.slides[index]
  end

  def default_slide
    Slide.new(name: "Default Slide", style: "markup", markup: "<h1>Slide Not Found</h1>")
  end
end
