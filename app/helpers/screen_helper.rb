# frozen_string_literal: true

module ScreenHelper
  def qr_code
    image_tag("data:image/gif;base64,R0lGODdhZQBlAIAAAAAAAP///ywAAAAAZQBlAAAC/4yPqcvtD+MDtNqLW9VU4W18XSKWVmiaHLB64lG66RvMMQMuOUzXPW/L+FiS3C1iHA2TRMRuMno6mEKkknpVAiVDVBOCPRWzzapU2up6zWQuW6zTkshvL7BuH8OrsvTysqX2t9emF+bXtwaYF8aU6LQ4JQf5NVfWA9JYSCmDZon4qUhIpHlZKXg3+bgaOugoeFQaaHV6mOdaKHsbq4ozaQuLGUUXqYsKVUtsmjp6C7b5SjkzO+sZR9p7Xb3JzJu8rOeMvA0unUK9m50Y9EHunl4ezS40Xwx9H4/fHSTK/h6cLyC5eqe4tMJjrh08awYb+jIVbV8zUQ4r0mKGDtfEQf8WO3Gj+DCiJXn2FHJMmJHPyI8oFyoDBvLYyWsiWwI0pvLfM4iRMmI8+CtopZp+jviMqVPcMaIPJbKymVRmpmxGQwrbyDDmmWEF+6nzOopkV5tbsY2tSvOq2J01sz4q9abtyx8rxzZ1qUKrUIk5f7rBN03vN7496wLFqsyjSbSM93ISPFCot5yNBz+eKbbs5MIanz7x9pfnN39gCcMprbQoZ4JOwaoEHQ6pa7UlAwe+rNiv39uaP94+inl17au5xf1OLbi3aIS75ZSNbFnS6dmL9eGGpxs5VOoIRT7H+7R4Qt7WVQdUHhV257tvAUsu3/om56NrZQcvF9/YunNKM5f/TDnXWfNpJNd5//UX4AqekBcdTizpZ1haea1H1nsCJTecWQxSdmCFBi6XGIEZoocgYqLlN6BnD654oYjRWfSdVCz+c5xMDcWIo2MAmRaeh+3ZZRWQMk532WcdRsXWV0Na492R2N2YIoBEIikhXMLh14piHGKpZYBbAsckf0V+tdmEVNpI3Y+Q1eXWTlJK+eV9XQrpZolwXrnmeErWOeSdRBpp5mGgXLekhdnVeGaYL9oXl3NiqsmeiqMZClJ9O0bKHkGIavPkpZxKZxprF3XKFJpjaopWR+OgZpByip4JJYh0ZskqpKbGGl9oc5oXCKotvgqeoHbqaQONVLnX4IzEozKYKLK2xqidpHOWCS2tJ7U57LK0/XnspGbpaq2oFIJJqYPJnsjotpUdxhypGe7KnY54FQhddhSSdp25ua4KKoYbsdthqph+2ui/p3ZHV78KF8yUvhESGlpfeU4lq5890iKxnIwkWGK1rSbcHDjYetquiwUPOjCveYb6bsqf8gmMq2JmjK2vFneaXsJNanqzpzmblJTNHcOHc61Fq4p00korUAAAOw==")
  end

  def now_time
    # Hour Minute AM/PM
    Time.now.strftime("%l:%M %p")
  end

  def dual_layout?
    @screen.layout == "dual"
  end

  def single_layout?
    @screen.layout == "single"
  end

  def screen_rotation
    "rotate-#{@screen.rotation}"
  end

  def slide_length
    @slide_length || 30
  end

  def next_slide_url
    @next_slide_url
  end

  def too_many_rooms?
    room_count = @screen.rooms.count

    (single_layout? && room_count > 1) ||
      (dual_layout? && room_count > 2)
  end

  def no_playlist?
    @screen.playlist.presence
  end
end
