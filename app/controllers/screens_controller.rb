class ScreensController < ApplicationController
  def index
    @screens = Screen.all.alpha_sorted
  end

  def show
    @screen = Screen.includes(:rooms).find(params[:id])
    @slide = find_slide(slide_index) || Slide.default_slide
    @slide = @slide.decorate
    @next_slide_url = screen_path(@screen, slide: next_slide_index)
    @slide_length = find_slide_length(slide_index)

    render layout: "screen"
  end

  private

  def next_slide_index
    possible_next_slide_index = slide_index + 1

    if find_slide(possible_next_slide_index)
      possible_next_slide_index
    else
      0
    end
  end

  def find_slide(index)
    find_playlist_slide(index).try(:slide)
  end

  def find_slide_length(index)
    find_playlist_slide(index).try(:length) || 30
  end

  def find_playlist_slide(index)
    @screen.playlist.presence &&
      @screen.playlist.playlist_slides[index]
  end


  def slide_index
    params[:slide] ||= 0
    params[:slide] = Integer(params[:slide])

    params[:slide]
  end
end
