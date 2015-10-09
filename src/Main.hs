{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty
import System.Environment
import qualified Network.Wai as W
import qualified Data.Text.Lazy as T
import qualified Network.Socket.Internal as S

main :: IO ()
main = do
    env <- getEnvironment
    let port = maybe 8080 read $ lookup "PORT" env
    scotty port $ do
      get "/" $ do
        req <- request
        let rh = W.remoteHost req
        text $ T.pack $ takeWhile (/=':') $ show rh
