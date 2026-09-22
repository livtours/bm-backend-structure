module Main where

import Test.Syd
import Unit.Spec qualified as Unit
import Prelude

main :: IO ()
main = sydTest $ do
    Unit.spec
