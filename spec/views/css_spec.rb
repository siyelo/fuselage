require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "css" do
  
  context "compiling from sass" do
    it "should compile without warnings" do
      output = `compass compile -f --boring 2>&1`
      output.should_not =~ /WARNING/i
    end
    
    it "should compile without errors" do
      output = `compass compile -f --boring 2>&1`
      output.should_not =~ /error/i
    end
  end
end