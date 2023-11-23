const mongoose = require("mongoose");

mongoose.set("strictQuery", false);
mongoose
  .connect('mongodb+srv://campusepsilon:campusepsilon@cluster0.buixfvy.mongodb.net/?retryWrites=true&w=majority', {
    useNewUrlParser: true,
  })
  .then(() => console.log("connected to mongoDB"))
  .catch((e) => console.log(e));

module.exports = mongoose;
