require 'mongo'
require 'json'
require 'cli/ui'
require 'faker'

mongouri = ENV['mongouri'] || 'mongodb://host.docker.internal'
dbname = ENV['dbname'] || 'test'
collname = ENV['collname'] || 'contacts'
sleeptime = (ENV['sleeptime'] || 1).to_i

seed_docs = [
  {
    :_id => 1,
    :name => 'Nitin',
    :address => '42 Al Arouba Street, Sharjah, UAE'
  },
  {
    :_id => 2,
    :name => 'Neil',
    :address => '66 TCHS, Mumbai, India'
  }
]

client = Mongo::Client.new mongouri
client = client.use dbname
seed_docs.each {|doc|
  client[collname].replace_one({:_id => doc[:_id]}, doc, upsert: true)
}

CLI::UI.frame_style= :bracket
CLI::UI::StdoutRouter.enable

loop do
  id_to_update = rand(1..2)

  init_doc = seed_docs.select{|doc| doc[:_id]==id_to_update}.first
  new_address = Faker::Address.full_address
  CLI::UI::Frame.open("Updating address for contact #{init_doc[:name]}") do

    puts CLI::UI.fmt "{{green:Executing}}"

    doc = client[collname].find_one_and_update(
      {_id: id_to_update},
      {'$set': {address: new_address}, '$inc': {revision: 1}},
      {upsert: true, return_document: :before}
    )
    # doc = JSON.parse(doc.to_extended_json, :symbolize_names => true)
    puts "
  doc = db.#{collname}.findOneAndUpdate(
    {_id: #{id_to_update}},
    {$set: {address: \"#{new_address}\"}, $inc: {revision: 1}}
  );
    "

    upserted_doc = client[collname].find({_id: id_to_update}).first
    upserted_doc_json = JSON.pretty_generate(upserted_doc)

    puts CLI::UI.fmt "{{green:Output Document}}"
    puts ''
    puts upserted_doc_json

    if !doc.nil?
      doc[:old_id] = doc[:_id]
      doc.delete(:_id)
      doc.delete('_id')
      retval = client[collname+'_history'].insert_one doc
      puts ''
      puts CLI::UI.fmt "{{green:Writing Revision}}"
      puts "
  doc.old_id = doc._id
  delete(doc._id);
  db.#{collname}_history.insertOne(doc);
      "

      revision_doc = client[collname+'_history'].find({_id: retval.inserted_ids.first}).first
      revision_doc_json = JSON.pretty_generate(revision_doc)
      puts CLI::UI.fmt "{{green:Revision History Document}}"
      puts ''
      puts revision_doc_json
    end

  end
  puts ''

  sleep sleeptime
end

