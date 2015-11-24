require "rails_helper"

shared_examples "React Component" do |dom_selector|
  scenario { is_expected.to have_css dom_selector }

  scenario "changes name in message according to input" do
    new_text = "John Doe"

    within(dom_selector) do
      find("input").set new_text
      within("h3") do
        is_expected.to have_content new_text
      end
    end
  end
end

feature "Pages/Index", js: true do
  subject { page }

  context "All in one page" do
    background do
      visit root_path
    end

    context "Server Rendered/Cached React/Redux Component" do
      include_examples "React Component", "div#ReduxApp-react-component-0"
    end

    context "Server Rendered/Cached React Component Without Redux" do
      include_examples "React Component", "div#HelloWorld-react-component-1"
    end

    context "Simple Client Rendered Component" do
      include_examples "React Component", "div#HelloWorldApp-react-component-2"

      context "same component with different props" do
        include_examples "React Component", "div#HelloWorldApp-react-component-3"
      end
    end

    context "Simple Component Without Redux" do
      include_examples "React Component", "div#HelloWorld-react-component-4"
      include_examples "React Component", "div#HelloWorldES5-react-component-5"
    end

    context "Non-React Component" do
      scenario { is_expected.to have_content "Time to visit Maui" }
    end
  end

  context "Server Rendering with Options" do
    background do
      visit server_side_hello_world_with_options_path
    end

    include_examples "React Component", "div#my-hello-world-id"
  end
end

feature "Pages/client_side_log_throw", js: true do
  subject { page }
  background { visit "/client_side_log_throw" }

  scenario { is_expected.to have_text "This example demonstrates client side logging and error handling." }
end

feature "Pages/server_side_log_throw", js: true do
  subject { page }
  background { visit "/server_side_log_throw" }

  scenario "page has server side throw messages" do
    expect(subject).to have_text "This example demonstrates server side logging and error handling."
    expect(subject).to have_text "Exception in rendering!\n\nMessage: throw in HelloWorldContainer"
  end
end

feature "Pages/server_side_log_throw_raise" do
  subject { page }
  background { visit "/server_side_log_throw_raise" }

  scenario "redirects to /client_side_hello_world and flashes an error" do
    expect(current_url).to eq("http://www.example.com/client_side_hello_world")
    flash_message = page.find(:css, ".flash").text
    expect(flash_message).to eq("Error prerendering in react_on_rails. See server logs.")
  end
end

feature "Pages/index after using browser's back button", js: true do
  subject { page }
  background do
    visit root_path
    visit "/client_side_hello_world"
    go_back
  end

  include_examples "React Component", "div#ReduxApp-react-component-0"
end
