module FeaturesSpec where

import Truth as Th
import Feature
import FeaturesRaw as Fr
import Test.Hspec
import Test.QuickCheck
import Tests as T
import FeaturesRaw as Raw
import Control.Lens
import Text.Pandoc.Options
import qualified Text.Pandoc.Class as PC
import Text.Pandoc.Readers.Markdown
import Text.Pandoc.Definition
import Data.Text (pack)

type Acc = ([Feature], Feature)

spec :: Spec
spec = do
  describe "Pandoc transformer" $ do
    it "should return a sample features list" $ do
      sample <- sampleFeatures Fr.sample
      (extractFeaturesFromPandoc sample) `shouldBe` expected
    it "should return a sample features list 2" $ do
      sample <- sampleFeatures Fr.sample2
      (extractFeaturesFromPandoc sample) `shouldBe` expected2
  where
    sampleFeatures :: String -> IO Pandoc
    sampleFeatures raw = fmap mapRes (PC.runIO $ readMarkdown def (pack raw))
    mapRes (Left _) = error "Could not read sample data"
    mapRes (Right d) = d
    expected = 
      Features {_features = [
        Feature {_featureName = "Network Launch", _userStories = [
          UserStory {_userStoryDesc = "UC: As a Coop SRE I want to launch a network", _criteria = [
            Criteria {_criteriaName = "AC: A succesful genesis ceremony", _testName = "test: [todo: requires integration test]", _status = Missing, _steps = [
              Step "ceremonyMaster is instatantied with flags --required-sigs 2 --duration 5min --interval 10sec --bonds-file <holds two nodes validatorA and validatorB.",
              Step "validatorA and validatorB joins p2p, both poining ceremonyMaster as bootstrap",
              Step "ceremonyMaster sends UnapprovedBlock to validatorA and validatorB",
              Step "validatorA and validatorB receives UnapprovedBlock",
              Step "validatorA and validatorB send back BlockApproval",
              Step "ceremonyMaster transitions to ApprovedBlockReceivedHandler",
              Step "ceremonyMaster sends ApprovedBlock to validatorA and validatorB",
              Step "validatorA and validatorB transition to ApprovedBlockReceivedHandler",
              Step "ceremonyMaster, validatorA and validatorB tip points to block (genesis) where it has no parent and Bonds holds validatorA and validatorB"]},
            Criteria {_criteriaName = "AC: A succesful genesis ceremony with read-only nodes joining", _testName = "test: [todo: requires integration test]", _status = Missing, _steps = [
              Step "ceremonyMaster is instatantied with flags --required-sigs 2 --duration 5min --interval 10sec --bonds-file <holds two nodes validatorA and validatorB.",
              Step "validatorA and validatorB joins p2p, both poining ceremonyMaster as bootstrap",
              Step "readOnlyA(read-only) joins p2p",
              Step "ceremonyMaster sends UnapprovedBlock to validatorA and validatorB",
              Step "validatorA and validatorB receives UnapprovedBlock",
              Step "validatorA and validatorB send back BlockApproval",
              Step "ceremonyMaster transitions to ApprovedBlockReceivedHandler",
              Step "ceremonyMaster sends ApprovedBlock to validatorA and validatorB",
              Step "validatorA and validatorB transition to ApprovedBlockReceivedHandler",
              Step "ceremonyMaster, validatorA and validatorB tip points to block (genesis) where it has no parent and Bonds holds validatorA and validatorB",
              Step "readOnlyA **never** transitions to ApprovedBlockReceivedHandler"]},
            Criteria {_criteriaName = "AC: A NOT succesful genesis ceremony (not enough sigs)", _testName = "test: [todo: requires integration test]", _status = Missing, _steps = [
              Step "ceremonyMaster is instatantied with flags --required-sigs 3 --duration 5min --interval 10sec --bonds-file <holds two nodes validatorA and validatorB.",
              Step "validatorA and validatorB joins p2p, both poining ceremonyMaster as bootstrap",
              Step "ceremonyMaster sends UnapprovedBlock to validatorA and validatorB",
              Step "validatorA and validatorB receives UnapprovedBlock",
              Step "validatorA and validatorB send back BlockApproval",
              Step "ceremonyMaster logs an error about not getting enough signatures on time (duration)"]},
            Criteria {_criteriaName = "AC: A validator catching up after ceremony", _testName = "test: [todo: requires integration test]", _status = Missing, _steps = [
              Step "genesis reach as described in A succesful genesis ceremony",
              Step "validatorC joins p2p, pointing on ceremonyMaster as bootstrap",
              Step "validatorC sends ApprobedBlockRequest to ceremonyMaster",
              Step "ceremonyMaster sends ApprovedBlock to validatorC",
              Step "validatorC transitions to ApprovedBlockReceivedHandler",
              Step "validatorC tip points to block (genesis) where it has no parent and Bonds holds validatorA and validatorB"]}]}]},
        Feature {_featureName = "Proof of stake consensus", _userStories = [
          UserStory {_userStoryDesc = "UC: As a dApp developer I want to be able to deploy my rholang contract to a validator", _criteria = [
            Criteria {_criteriaName = "AC: A correct contract gets deployed successfully", _testName = "test: [todo: requires integration test]", _status = Missing, _steps = [
              Step "instantiate p2p network with single ceremonyMaster that transitions to ApprovedBlockReceivedhandler (--required-sig 0)",
              Step "call rnode deploy with rholang/examples/tut-philosophers.rho on ceremonyMaster",
              Step "assert a success on std out",
              Step "rnode deploy exit code should be 0"]},
            Criteria {_criteriaName = "AC: An incorrect contract does not get deployed", _testName = "test: [todo: requires integration test]", _status = Missing, _steps = [
              Step "instantiate p2p network with single ceremonyMaster that transitions to ApprovedBlockReceivedhandler (--required-sig 0)",
              Step "call rnode deploy with invalid contract on ceremonyMaster",
              Step "assert a error logs on std out",
              Step "rnode deploy exit code should be 1"]}]},
          UserStory {_userStoryDesc = "UC: No AC!", _criteria = []}]}]}
    expected2 = 
      Features {_features = [
        Feature {_featureName = "Peer to Peer Network", _userStories = [
          UserStory {_userStoryDesc = "As a Node operator, I want to be able to bootstrap to the network by connecting to any known node", _criteria = []},
          UserStory {_userStoryDesc = "As a Node operator, once connected via a bootstrap node, I want to discover and connect to peers", _criteria = []},
          UserStory {_userStoryDesc = "As a Node operator, I want to know how many peers I am connected to", _criteria = []}]},
        Feature {_featureName = "Network Launch", _userStories = [
          UserStory {_userStoryDesc = "As a Coop SRE I want to launch a network", _criteria = [
            Criteria {_criteriaName = "A succesful genesis ceremony", _testName = "test: test/test_genesis_ceremony.py::test_successful_genesis_ceremony", _status = Missing, _steps = [
              Step "ceremonyMaster is instatantied with flags --required-sigs 2 --duration 5min --interval 10sec --bonds-file <holds two nodes validatorA and validatorB.",
              Step "validatorA and validatorB joins p2p, both pointing to ceremonyMaster as bootstrap",
              Step "ceremonyMaster sends UnapprovedBlock to validatorA and validatorB",
              Step "validatorA and validatorB receives UnapprovedBlock",
              Step "validatorA and validatorB send back BlockApproval",
              Step "ceremonyMaster transitions to ApprovedBlockReceivedHandler",
              Step "ceremonyMaster sends ApprovedBlock to validatorA and validatorB",
              Step "validatorA and validatorB transition to ApprovedBlockReceivedHandler",
              Step "ceremonyMaster, validatorA and validatorB tip points to block (genesis) where it has no parent and Bonds holds validatorA and validatorB"]},
            Criteria {_criteriaName = "A succesful genesis ceremony with read-only nodes joining", _testName = "test: not available", _status = Missing, _steps = [
              Step "ceremonyMaster is instatantied with flags --required-sigs 2 --duration 5min --interval 10sec --bonds-file <holds two nodes validatorA and validatorB.",
              Step "validatorA and validatorB joins p2p, both pointing to ceremonyMaster as bootstrap",
              Step "readOnlyA(read-only) joins p2p",
              Step "ceremonyMaster sends UnapprovedBlock to validatorA and validatorB",
              Step "validatorA and validatorB receives UnapprovedBlock",
              Step "validatorA and validatorB send back BlockApproval",
              Step "ceremonyMaster transitions to ApprovedBlockReceivedHandler",
              Step "ceremonyMaster sends ApprovedBlock to validatorA and validatorB",
              Step "validatorA and validatorB transition to ApprovedBlockReceivedHandler",
              Step "ceremonyMaster, validatorA and validatorB tip points to block (genesis) where it has no parent and Bonds holds validatorA and validatorB",
              Step "readOnlyA **never** transitions to ApprovedBlockReceivedHandler"]},
            Criteria {_criteriaName = "A NOT succesful genesis ceremony (not enough sigs)", _testName = "test: not available", _status = Missing, _steps = [
              Step "ceremonyMaster is instatantied with flags --required-sigs 3 --duration 5min --interval 10sec --bonds-file <holds two nodes validatorA and validatorB.",
              Step "validatorA and validatorB joins p2p, both pointing to ceremonyMaster as bootstrap",
              Step "ceremonyMaster sends UnapprovedBlock to validatorA and validatorB",
              Step "validatorA and validatorB receives UnapprovedBlock",
              Step "validatorA and validatorB send back BlockApproval",
              Step "ceremonyMaster logs an error about not getting enough signatures on time (duration)"]},
            Criteria {_criteriaName = "A validator catching up after ceremony", _testName = "test: not available", _status = Missing, _steps = [
              Step "genesis reached as described in \"A succesful genesis ceremony\"",
              Step "validatorC joins p2p, pointing on ceremonyMaster as bootstrap",
              Step "validatorC sends ApprovedBlockRequest to ceremonyMaster",
              Step "ceremonyMaster sends ApprovedBlock to validatorC",
              Step "validatorC transitions to ApprovedBlockReceivedHandler",
              Step "validatorC tip points to block (genesis) where it has no parent and Bonds holds validatorA and validatorB"]}]}]},
        Feature {_featureName = "Bonding/Unbonding", _userStories = [
          UserStory {_userStoryDesc = "As a Node Validator, I want to be able to add my stake to the network and be recognized as a validator so I can participate in proof of stake consensus and be eligible to earn rewards (validating)", _criteria = []},
          UserStory {_userStoryDesc = "As a Node Validator, I want to be able to retrieve my stake from the network and no longer be recognized a as validator", _criteria = []}]},
        Feature {_featureName = "Proof of stake consensus", _userStories = [
          UserStory {_userStoryDesc = "As a dApp developer I want to be able to deploy my rholang contract to a validator", _criteria = [
            Criteria {_criteriaName = "A correct contract gets deployed successfully", _testName = "test: not available", _status = Missing, _steps = [
              Step "instantiate p2p network with single ceremonyMaster that transitions to ApprovedBlockReceivedhandler (--required-sig 0)",
              Step "call rnode deploy with rholang/examples/tut-philosophers.rho on ceremonyMaster",
              Step "assert a success on std out",
              Step "rnode deploy exit code should be 0"]},
            Criteria {_criteriaName = "An incorrect contract does not get deployed", _testName = "test: not available", _status = Missing, _steps = [
              Step "instantiate p2p network with single ceremonyMaster that transitions to ApprovedBlockReceivedhandler (--required-sig 0)",
              Step "call rnode deploy with invalid contract on ceremonyMaster",
              Step "assert a error logs on std out",
              Step "rnode deploy exit code should be 1"]}]}]}]}
