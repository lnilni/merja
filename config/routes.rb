Merja::Engine.routes.draw do
  root "items#show"
  get "*a" => "items#show"
end
