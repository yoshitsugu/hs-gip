{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty
import System.Environment
import Data.CaseInsensitive
import qualified Network.Wai as W
import qualified Data.Text.Lazy as T
import qualified Data.ByteString.Internal as B
import qualified Data.ByteString.Char8 as BC
import Network.HTTP.Types.Header (RequestHeaders, Header)

main :: IO ()
main = do
    env <- getEnvironment
    let port = maybe 8080 read $ lookup "PORT" env
    scotty port $ do
      get "/" $ do
        req <- request
        let rh = W.remoteHost req
        let headers = W.requestHeaders req
        let x = getXForwardedFor headers
        text $ T.pack $ (if hasXForwadedFor x then (BC.unpack $ snd $ head x) else (takeWhile (/=':') $ show rh)) ++ "\n"

  where
    getXForwardedFor :: RequestHeaders -> [Header]
    getXForwardedFor = filter (\(a,_) -> a == ("X-Forwarded-For" :: CI B.ByteString))

    hasXForwadedFor :: [Header] -> Bool
    hasXForwadedFor = (> 0) . length
