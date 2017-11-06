# Copyright 2017, Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "helper"

describe Google::Cloud::Firestore::Batch, :collection, :mock_firestore do
  let(:batch) { Google::Cloud::Firestore::Batch.from_database firestore }

  it "gets a collection by a collection_id" do
    col = batch.col "users"

    col.must_be_kind_of Google::Cloud::Firestore::Collection::Reference
    col.collection_id.must_equal "users"
    col.collection_path.must_equal "users"
    col.path.must_equal "projects/#{project}/databases/(default)/documents/users"

    col.context.must_equal batch
  end

  it "gets a collection by a nested collection path" do
    col = batch.col "users/mike/messages"

    col.must_be_kind_of Google::Cloud::Firestore::Collection::Reference
    col.collection_id.must_equal "messages"
    col.collection_path.must_equal "users/mike/messages"
    col.path.must_equal "projects/#{project}/databases/(default)/documents/users/mike/messages"

    col.context.must_equal batch
  end

  it "does not allow a document path" do
    error = expect do
      batch.col "users/mike"
    end.must_raise ArgumentError
    error.message.must_equal "collection_path must refer to a collection."
  end

  describe "using collection alias" do
    it "gets a collection by a collection_id" do
      col = batch.collection "users"

      col.must_be_kind_of Google::Cloud::Firestore::Collection::Reference
      col.collection_id.must_equal "users"
      col.collection_path.must_equal "users"
      col.path.must_equal "projects/#{project}/databases/(default)/documents/users"

      col.context.must_equal batch
    end

    it "gets a collection by a nested collection path" do
      col = batch.collection "users/mike/messages"

      col.must_be_kind_of Google::Cloud::Firestore::Collection::Reference
      col.collection_id.must_equal "messages"
      col.collection_path.must_equal "users/mike/messages"
      col.path.must_equal "projects/#{project}/databases/(default)/documents/users/mike/messages"

      col.context.must_equal batch
    end

    it "does not allow a document path" do
      error = expect do
        batch.collection "users/mike"
      end.must_raise ArgumentError
      error.message.must_equal "collection_path must refer to a collection."
    end
  end
end