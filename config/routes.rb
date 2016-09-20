ActiveVersioning::Workflow::Engine.routes.draw do
  get '/live-preview', to: 'workflow/live_preview#show'
end
