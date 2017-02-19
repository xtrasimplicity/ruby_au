require 'rails_helper'

describe ApplicationController do

	describe 'raise_http_error' do
		controller do
			# Mock an :index action, and call it later (`get :index, code: CODE`), so we can have ActionController generate a @request and @respond object. 
			def index
				raise_http_error params[:code]
			end
		end

		context "an error-page template for this HTTP status code" do
		
			context "does not exist" do
				let(:status_code) { 508 }

				before { get :index, code: status_code }

				it "returns the correct status code" do
					expect(response).to have_http_status status_code
				end
			end

			context "does exist" do
				let(:public_path) { File.join(Rails.root, 'public') }
				let(:status_code) do
					# Get a status code that exists, using the first file in the public/ directory, 
					# which has a filename exactly 3 digits in length.
					Dir.glob(File.join(public_path, '*.*')).grep(/(\d{3})\.html/) { $1 }.first
				end

				before { get :index, code: status_code }

				it 'returns the correct status code' do
					expect(response).to have_http_status status_code
				end

				it 'renders the desired custom template' do
					expect(response).to render_template(file: File.join(public_path, "#{status_code}.html"))
				end
			end
		end
	end
end