RSpec.shared_examples "a standard view" do
  it "renders" do
    render
  end

  it "sets content for title" do
    render
    expect(view.content_for(:title)).not_to be_nil
  end
end