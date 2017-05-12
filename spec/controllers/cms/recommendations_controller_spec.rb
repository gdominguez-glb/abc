# require 'rails_helper'
#
# RSpec.describe Cms::RecommendationsController, type: :controller do
#   let(:recommendation) { create(:recommendation) }
#
#   let(:valid_attributes){ FactoryGirl.attributes_for :recommendation }
#   let(:invalid_attributes) { {title: nil} }
#
#   login_admin
#
#   describe "GET #index" do
#     it "assigns @recommendations" do
#       get :index
#       recommendation
#       expect(assigns(:recommendations)).to eq([recommendation])
#     end
#   end
#
#   describe "GET #new" do
#     it "assigns a new recommendation" do
#       get :new
#       expect(assigns(:recommendation)).to be_a_new(Recommendation)
#     end
#   end
#
#   describe "GET #edit" do
#     it "assigns the requested recommendation as @recommendation" do
#       get :edit, params: {id: recommendation.to_param}
#       expect(assigns(:recommendation)).to eq(recommendation)
#     end
#   end
#
#   describe "POST #create" do
#     context "with valid params" do
#       it "creates a new Recommendation" do
#         expect {
#           post :create, params: {recommendation: valid_attributes}
#         }.to change(Recommendation, :count).by(1)
#       end
#
#       it "assigns a newly created recommendation as @recommendation" do
#         post :create, params: {recommendation: valid_attributes}
#         expect(assigns(:recommendation)).to be_a(Recommendation)
#         expect(assigns(:recommendation)).to be_persisted
#       end
#
#       it "redirects to the recommendations path" do
#         post :create, params: {recommendation: valid_attributes}
#         expect(response).to redirect_to(cms_recommendations_path)
#       end
#     end
#
#     context "with invalid params" do
#       it "assigns a newly created but unsaved recommendation as @recommendation" do
#         post :create, params: {recommendation: invalid_attributes}
#         expect(assigns(:recommendation)).to be_a_new(Recommendation)
#       end
#
#       it "re-renders the 'new' template" do
#         post :create, params: {recommendation: invalid_attributes}
#         expect(response).to render_template(:new)
#       end
#     end
#   end
#
#   describe "PUT #update" do
#     context "with valid params" do
#       let(:new_attributes) { {title: 'Newest'} }
#
#       it "updates the requested recommendation" do
#         put :update, params: {id: recommendation.to_param, recommendation: new_attributes}
#         recommendation.reload
#         expect(recommendation.title).to eq('Newest')
#       end
#
#       it "assigns the requested recommendation as @recommendation" do
#         put :update, params: {id: recommendation.to_param, recommendation: valid_attributes}
#         expect(assigns(:recommendation)).to eq(recommendation)
#       end
#
#       it "redirects to the recommendation" do
#         put :update, params: {id: recommendation.to_param, recommendation: valid_attributes}
#         expect(response).to redirect_to(cms_recommendations_path)
#       end
#     end
#
#     context "with invalid params" do
#       it "assigns the recommendation as @recommendation" do
#         put :update, params: {id: recommendation.to_param, recommendation: invalid_attributes}
#         expect(assigns(:recommendation)).to eq(recommendation)
#       end
#
#       it "re-renders the 'edit' template" do
#         recommendation
#         put :update, params: {id: recommendation.to_param, recommendation: invalid_attributes}
#         expect(response).to render_template(:edit)
#       end
#     end
#   end
#
#   describe "DELETE #destroy" do
#     it "destroys the requested recommendation" do
#       expect {
#         delete :destroy, params: {id: recommendation.to_param}
#       }.to change(Recommendation, :count).by(-1)
#     end
#
#     it "redirects to the cms_recommendations_path list" do
#       delete :destroy, params: {id: recommendation.to_param}
#       expect(response).to redirect_to(cms_recommendations_path)
#     end
#   end
#
#   describe "GET #preview" do
#     it "assigns @recommendations" do
#       get :preview, params: {id: recommendation.to_param}
#       recommendation
#       expect(assigns(:recommendations)).to eq([recommendation])
#     end
#   end
# end