class WelcomeController < ApplicationController
  # Setting the layout here changes the default layout for
  # all the actions in this controller.
  # layout "special"

  def index
    # render({test: "Hello World"})

    # render text: "Hello World"

    # Rails automatically renders a template with the views subfolder rmatching
    # the controllers name. In this case the welcome folder. It will look for a
    # file name index with the appropriate format and templating language
    # so we can write this but it's redundant:
    # NOTE: the name of the layout file should be a string vs a symbol in Sinatra
    # render(:index, {layout: "application"})
    render :index, layout: "application"
  end
end
