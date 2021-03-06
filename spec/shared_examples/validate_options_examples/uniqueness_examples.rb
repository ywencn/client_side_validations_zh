shared_examples_for 'Uniqueness' do
  context 'Uniquness' do
    before do
      Object.send(:remove_const, :Klass)
      define_abstract_ar(:Klass, ActiveRecord::Base)
    end
    
    context 'default' do
      before do
        Klass.class_eval do
          validates_uniqueness_of :string
        end
      
        @result = Klass.new.validate_options
      end
    
      it 'should translate the rule' do
        @result['rules']['string']['remote'].should == {'url' => '/validations/uniqueness.json', 'data' => {}}
        @result['rules']['string']['required'].should be_true
      end
    
      it 'should translate the message' do
        @result['messages']['string']['remote'].should == "has already been taken"
        @result['messages']['string']['required'].should == "has already been taken"
      end
    end
  
    context 'allow blank is false' do
      before do
        Klass.class_eval do
          validates_uniqueness_of :string, :allow_blank => false
        end
      
        @result = Klass.new.validate_options
      end
    
      it 'should translate the rule' do
        @result['rules']['string']['remote'].should == {'url' => '/validations/uniqueness.json', 'data' => {}}
        @result['rules']['string']['required'].should be_true
      end
    
      it 'should translate the message' do
        @result['messages']['string']['remote'].should == "has already been taken"
        @result['messages']['string']['required'].should == "has already been taken"
      end
    end

    context 'allow blank is true' do
      before do
        Klass.class_eval do
          validates_uniqueness_of :string, :allow_blank => true
        end
      
        @result = Klass.new.validate_options
      end
    
      it 'should translate the rule' do
        @result['rules']['string']['remote'].should == {'url' => '/validations/uniqueness.json', 'data' => {}}
        @result['rules']['string']['required'].should be_nil
      end
    
      it 'should translate the message' do
        @result['messages']['string']['remote'].should == "has already been taken"
        @result['messages']['string']['required'].should be_nil
      end
    end
  
    context 'existing record' do
      before do
        Klass.class_eval do
          validates_uniqueness_of :string
        end
      
        instance = Klass.new
        instance.stubs(:new_record?).returns(false)
        instance.stubs(:id).returns(1)
      
        @result = instance.validate_options
      end
    
      it 'should translate the rule' do
        @result['rules']['string']['remote'].should == {'url' => '/validations/uniqueness.json', 'data' => { 'klass[id]' => 1}}
        @result['rules']['string']['required'].should be_true
      end
    
      it 'should translate the message' do
        @result['messages']['string']['remote'].should == "has already been taken"
        @result['messages']['string']['required'].should == "has already been taken"
      end
    end
  end
end