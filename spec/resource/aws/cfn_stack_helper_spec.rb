require 'cloudat/aws/cfn_stack_helper'

describe Cloudat::Aws::CfnStackHelper do
  let(:stack) { double('Aws::CloudFormation::Stack') }
  let(:stack_helper) {Cloudat::Aws::CfnStackHelper.new}

  describe '#unique_stack_id?' do
    context 'when called with :stack_name and a string' do
      subject do
        stack_helper.unique_stack_id? stack_name: 'test'
      end
      it { is_expected.to be true }
    end

    context 'when called with :stack_name and a Regexp' do
      subject do
        stack_helper.unique_stack_id? stack_name: /test/
      end
      it { is_expected.to be false }
    end

    context 'when called with :stack_id and a string' do
      subject do
        stack_helper.unique_stack_id? stack_id: 'test'
      end
      it { is_expected.to be true }
    end

    context 'when called with :stack_id and a Regexp' do
      subject do
        stack_helper.unique_stack_id? stack_id: /test/
      end
      it { is_expected.to be false }
    end

    context 'when called with :stack_fake_param and a String' do
      subject do
        stack_helper.unique_stack_id? stack_fake_param: /test/
      end
      it { is_expected.to be false }
    end
  end

  describe '#selected?' do
    subject do
      stack_helper.selected? stack, stack_name: /test/
    end

    before do
      expect(stack_helper).to receive(:matches?)
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
      subject do
        stack_helper.matches? stack, :stack_name, /good/
      end

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
