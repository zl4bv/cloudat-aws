# Cloudat::Aws

[![Build Status](https://travis-ci.org/zl4bv/cloudat.svg?branch=master)](https://travis-ci.org/zl4bv/cloudat)

AWS provider for cloudat

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloudat-aws'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloudat-aws

## Usage

Adds the following functionalities to [cloudat](https://github.com/zl4bv/cloudat):

### Cloudformation stacks
#### Actions
  * destroy: deletes a stack

#### Resources
  * Locate a stack from its arn
```ruby
destroy cfn_stack '<stack arn>'
```
  * Locate stacks by their stack name or id using RegExps
```ruby
destroy cfn_stacks stack_name: /stack_nam.*/
destroy cfn_stacks stack_id: %r{^arn:aws:cloudformation:.*:.*:stack/test-stack}
```

### EC2 instances
#### Actions
 * start: [Starts an EC2 instance](http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Instance.html#start-instance_method)
 * stop: [Stops an EC2 instance](http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Instance.html#stop-instance_method)
 * terminate: [Terminates an EC2 instance](http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Instance.html#terminate-instance_method)

### AutoScaling groups
#### Actions
 * suspend: [Suspends AutoScaling processes](http://docs.aws.amazon.com/AutoScaling/latest/APIReference/API_SuspendProcesses.html)
 * resume: [Resumes AutoScaling processes](http://docs.aws.amazon.com/AutoScaling/latest/APIReference/API_ResumeProcesses.html)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/cloudat-aws/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
