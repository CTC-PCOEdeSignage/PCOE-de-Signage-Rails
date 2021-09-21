class LameMailer < ApplicationMailer
  def go(from: "DoNotReply@ohio.edu", to: "ricky@rickychilcott.com", subject: "Hi!", body: "Render text")
    mail(from: from, to: to, subject: subject) do |format|
      format.text { render plain: body }
    end
  end
end

# LameMailer.go.deliver_now
# LameMailer.go(to: "rc324204@ohio.edu").deliver_now
# LameMailer.go(to: "rc324204@ohio.edu", from: "coe-projrms-sa@ohio.edu").deliver_now
