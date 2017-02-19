shared_examples 'a HTTP error was thrown' do |error_code|
    it "should respond with a #{error_code} error" do
        expect(response).to have_http_status error_code    
    end

    it "renders a #{error_code} page" do
        expect(response).to render_template(file: File.join(Rails.root, 'public', "#{error_code}.html"))    
    end
end