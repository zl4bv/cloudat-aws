require 'cloudat'
require 'cloudat/resource/aws/cfn_stack_resource'

describe Cloudat::Resource::Aws::CfnStackResource do
  let(:stack_resource) do
    Cloudat::Resource::Aws::CfnStackResource.new('config',
                                                 'test-id')
  end
  let(:stack) { double('Aws::CloudFormation::Stack') }

  describe '#find' do
    context 'when called with a stack name' do
      subject { stack_resource.find(nil, stack_name: 'test_stack') }

      it 'is expected to use the optimized method of the aws sdk' do
        expect(stack_resource).to receive(:find_stack)
      end
    end

    context 'when called with a Regexp' do
      subject { stack_resource.find(nil, stack_name: /test_stack/) }

      it 'is expected to return a list of Stacks' do
        expect(stack_resource).to receive_message_chain(:resource, :stacks).and_return [stack]
        expect(stack_resource).to receive(:unique_stack_id?).and_return false
        expect(stack_resource).to receive(:selected?).and_return true

        expect(subject).to include stack
      end
    end
  end

  describe '#unique_stack_id?' do
    context 'when called with :stack_name and a string' do
      subject do
        stack_resource.send(:unique_stack_id?,
                            stack_name: 'test'
                           )
      end
      it { is_expected.to be true }
    end

    context 'when called with :stack_name and a Regexp' do
      subject do
        stack_resource.send(:unique_stack_id?,
                            stack_name: /test/
                           )
      end
      it { is_expected.to be false }
    end

    context 'when called with :stack_id and a string' do
      subject do
        stack_resource.send(:unique_stack_id?,
                            stack_id: 'test'
                           )
      end
      it { is_expected.to be true }
    end

    context 'when called with :stack_id and a Regexp' do
      subject do
        stack_resource.send(:unique_stack_id?,
                            stack_id: /test/
                           )
      end
      it { is_expected.to be false }
    end

    context 'when called with :stack_fake_param and a String' do
      subject do
        stack_resource.send(:unique_stack_id?,
                            stack_fake_param: /test/
                           )
      end
      it { is_expected.to be false }
    end
  end

  describe '#selected?' do
    subject { stack_resource.send(:selected?, stack, stack_name: /test/) }

    before do
      expect(stack_resource).to receive(:matches?)
        .with(stack, :stack_name, /test/).and_return does_stack_exist
    end

    context 'when called with an existing stack_name' do
      let(:does_stack_exist) { true }

      it { is_expected.to be true }
    end

    context 'when called with an inexistant stack_name' do
      let(:does_stack_exist) { false }

      it { is_expected.to be false }
    end
  end

  describe '#matches?' do
    context 'when called with stack_name' do
      subject { stack_resource.send(:matches?, stack, :stack_name, /good/) }
      before do
        expect(stack).to receive(:stack_name).and_return stack_name
      end

      context 'when a stack with that name exists' do
        let(:stack_name) { 'good_stack' }

        it { is_expected.to be true }
      end

      context 'when a stack with that name does not exist' do
        let(:stack_name) { 'bad_stack' }

        it { is_expected.to be false }
      end
    end
  end
end
