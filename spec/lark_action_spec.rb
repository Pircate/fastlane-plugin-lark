describe Fastlane::Actions::LarkAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The lark plugin is working!")

      Fastlane::Actions::LarkAction.run(nil)
    end
  end
end
