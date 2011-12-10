require 'spec_helper'

module CSL
	
	describe 'Node' do
		
		describe '.new' do

			# Most of the examples below were adapted from the Ruby Specs
			# for Struct.new from the Rubinius project.
			# Copyright (c) 2008 Engine Yard, Inc. All rights reserved.
			
		  it 'creates a constant in Node namespace from passed-in string argument' do
		    node = Node.new('Color', :red, :green, :yellow)
		    node.should == Node::Color
		    node.name.should == 'CSL::Node::Color'
		  end

		  it 'overwrites previously defined constants with same name' do
		    first = Node.new('Point', :x, :y)
		    first.should == Node::Point

		    second = Node.new('Point', :alpha, :length)
		    second.should == Node::Point

		    first.members.should_not == second.members
		  end

	    it 'creates a new anonymous class when first argument is nil' do
	      node = Node.new(nil, :foo)
	      node.new('bar').foo.should == 'bar'
	      node.should be_a(Class)
	      node.name.to_s.should == ''
	    end

	    it 'creates a new anonymous class with symbol arguments' do
	      node = Node.new(:make, :model)
	      node.should be_a(Class)
	      node.name.to_s.should == ''
	    end

	    it 'creates a new anonymous class when first argument is nil' do
	      node = Node.new(nil, :foo)
	      node.new('bar').foo.should == 'bar'
	      node.should be_a(Class)
	      node.name.should be_nil
	    end

	    it 'creates a new anonymous class with symbol arguments' do
	      node = Node.new(:make, :model)
	      node.should be_a(Class)
	      node.name.should == nil
	    end

		  it 'does not create a constant with symbol as first argument' do
		    node = Node.new(:Animal, :name, :legs, :eyeballs)
		    Node.const_defined?('Animal').should be_false
		  end


		  it 'fails with invalid constant name as first argument' do
		    lambda { Node.new('animal', :name, :legs, :eyeballs) }.should raise_error(NameError)
		  end

		  it "raises a TypeError if object doesn't respond to to_sym" do
		    lambda { Node.new(:animal, 1.0)                  }.should raise_error(TypeError)
		    lambda { Node.new(:animal, Time.now)             }.should raise_error(TypeError)
		    lambda { Node.new(:animal, Class)                }.should raise_error(TypeError)
		    lambda { Node.new(:animal, nil)                  }.should raise_error(TypeError)
		    lambda { Node.new(:animal, true)                 }.should raise_error(TypeError)
		    lambda { Node.new(:animal, ['chris', 'evan'])    }.should raise_error(TypeError)
		    lambda { Node.new(:animal, { :name => 'chris' }) }.should raise_error(TypeError)
		  end


	    it "processes passed block with instance_eval" do
	      klass = Node.new(:something) { @something_else = 'something else entirely!' }
	      klass.instance_variables.map(&:to_sym).should include(:@something_else)
	    end

			describe '.new of the returned class' do
				before(:all) { Node.new('Point2d', :x, :y) }

				it 'creates an instance' do
					Node::Point2d.new.should be_a(Node::Point2d)
				end

				it 'creates reader methods' do
					Node::Point2d.new.should respond_to(:x)
					Node::Point2d.new.should respond_to(:y)
				end

				it 'creates writer methods' do
					Node::Point2d.new.should respond_to(:x=)
					Node::Point2d.new.should respond_to(:y=)
				end

				it 'fails with too many arguments' do
					lambda { Node::Point2d.new(2.0, 1, true) }.should raise_error(ArgumentError)
				end
			end



		end

	end

end