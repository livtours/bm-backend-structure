module Unit.CommonSpec where

import BluePrelude
import Common
import Model.Fields
import Test.Syd
import Prelude

spec :: Spec
spec = describe "foo" $ do
    it "equals bar" $ do
        foo `shouldBe` bar

api :: (String, String, Int)
api = (foo, bar, fortytwo)
