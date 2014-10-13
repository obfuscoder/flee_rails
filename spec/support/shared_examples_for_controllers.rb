RSpec.shared_examples "a standard controller" do
  let(:models) { described_class.controller_name.to_sym }
  let(:model) { models.to_s.singularize.to_sym }
  let(:model_class) { model.to_s.camelcase.constantize }
  let(:additional_attributes) { respond_to?(:virtual_attributes) ? virtual_attributes : {} }
  let!(:model_instance) { FactoryGirl.create(model) }

  describe "GET index" do
    before do
      get :index
    end

    it "assigns all model instances as @models" do
      expect(assigns(models)).to match_array([model_instance])
    end

    it { expect(response).to render_template("index") }
    it { expect(response).to have_http_status :ok }
  end

  describe "GET show" do
    before do
      get :show, id: model_instance.to_param
    end

    it "assigns the requested model instance as @model" do
      expect(assigns(model)).to eq(model_instance)
    end

    it { expect(response).to render_template("show") }
    it { expect(response).to have_http_status :ok }
  end

  describe "GET new" do
    before do
      get :new
    end

    it "assigns a new model instance as @model" do
      expect(assigns(model)).to be_a_new(model_class)
    end

    it { expect(response).to render_template("new") }
    it { expect(response).to have_http_status :ok }
  end

  describe "GET edit" do
    before do
      get :edit, id: model_instance.to_param
    end

    it "assigns the requested model instance as @model" do
      expect(assigns(model)).to eq(model_instance)
    end

    it { expect(response).to render_template("edit") }
    it { expect(response).to have_http_status :ok }
  end

  describe "POST create" do
    context "with valid params" do
      def call_post
        post :create, model => FactoryGirl.build(model).attributes.merge(additional_attributes)
      end

      before do
        call_post
      end

      it "creates a new model instance" do
        expect { call_post }.to change(model_class, :count).by(1)
      end

      it { expect(assigns(model)).to be_a(model_class) }
      it { expect(assigns(model)).to be_persisted }
      it { expect(response).to redirect_to(model_class.last) }
    end

    context "with invalid params" do
      before do
        post :create, model => {name: nil}
      end

      it { expect(assigns(model)).to be_a_new(model_class) }
      it { expect(response).to render_template("new") }
      it { expect(response).to have_http_status :ok }
    end
  end

  describe "PUT update" do
    before do
      put :update, id: model_instance.to_param, model => new_attributes
      model_instance.reload
    end

    context "with valid params" do
      let(:new_attributes) { valid_update_attributes }

      it { expect(assigns(model)).to eq(model_instance) }
      it "updates the attributes of the model instance" do
        new_attributes.keys.each do |attribute|
          expect(model_instance[attribute]).to eq(new_attributes[attribute])
        end
      end
      it { expect(response).to redirect_to(model_instance) }
    end

    context "with invalid params" do
      let(:new_attributes) { invalid_update_attributes }

      it { expect(assigns(model)).to eq(model_instance) }
      it { expect(response).to render_template("edit") }
      it { expect(response).to have_http_status :ok }
    end
  end

  describe "DELETE destroy" do
    let(:delete_action) { delete :destroy, id: model_instance.to_param }

    it { expect { delete_action }.to change(model_class, :count).by(-1) }

    it "redirects to the categories list" do
      delete_action
      expect(response).to redirect_to(eval "#{models}_path")
    end
  end
end