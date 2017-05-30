cities = ~w[Hamburg Berlin Köln Kassel München Düsseldorf Leipzig Dresden Frankfurt Wiesbaden Bremen]

num_records = 356 * 24

file_stream = File.stream!("output.csv", [:write])

for city <- cities, _ <- 1..num_records do
  [city, :rand.normal() * 20 + 10]
end
|> Enum.shuffle()
|> CSV.encode()
|> Stream.into(file_stream)
|> Stream.run
