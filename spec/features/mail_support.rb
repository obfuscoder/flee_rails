# frozen_string_literal: true

def send_and_open_email(email)
  Delayed::Worker.new.work_off
  open_email email
end
