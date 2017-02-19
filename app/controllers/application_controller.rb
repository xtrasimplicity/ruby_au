class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private 

  def raise_http_error(error_code)
    template_file = File.join(Rails.root, 'public', error_code.to_s)

    begin
      return render file: template_file, status: error_code
    rescue ActionView::MissingTemplate
      return head(error_code)
    end

  end
end
