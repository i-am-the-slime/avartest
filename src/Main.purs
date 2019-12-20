module Main where

import Prelude

import Effect (Effect)
import Effect.AVar as AVar
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Milkis (Fetch, defaultFetchOptions)
import Milkis as M
import Milkis.Impl.Node (nodeFetch)

fetch :: Fetch
fetch = M.fetch nodeFetch

fetchGoogle :: Aff Unit
fetchGoogle = do
  response <- fetch (M.URL "https://google.com/q=bierchen") defaultFetchOptions
  rawResponse <- M.text response
  log $ rawResponse

main :: Effect Unit
main = do
  log "Hi"
  lock <- AVar.empty
  launchAff_ do
    fetchGoogle
    AVar.tryPut "done" lock # liftEffect
  AVar.read lock (\_ -> pure unit) # void