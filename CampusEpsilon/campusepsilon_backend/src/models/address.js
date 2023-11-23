const mongoose = require("mongoose");
const validator = require("validator");
const ObjectID = mongoose.Schema.Types.ObjectId;

const addressSchema = new mongoose.Schema(
  {
    owner: {
      type: ObjectID,
      required: true,
      ref: "User",
    },
    label: {
      type: String,
      default: "Home",
      minLength: 3,
      maxLength: 30,
    },
    complete_address: {
      type: String,
      required: true,
      minLength: 3,
      maxLength: 200,
    },
    notes: {
      type: String,
      required: false,
      maxLength: 45,
    },
    receiver_name: {
      type: String,
      required: true,
      minLength: 2,
      maxLength: 50,
    },
    receiver_phone: {
      type: String,
      required: true,
      minLength: 9,
      maxLength: 15,
      validate(value) {
        value = normalizePhone(value);
        if (!validator.isMobilePhone(value + "", ["bn-BD"])) {
          throw new Error("Phone is invalid");
        }
      },
    },
  },
  {
    timestamps: true,
  }+
);
const normalizePhone = (phone) => {
  phone = String(phone).trim();
  if (phone.startsWith("88")) {
    phone = "+" + phone;
  } else if (phone.startsWith("01")) {
    phone = "+88" + phone.slice();
  }
  return phone.replace(/[- .]/g, "");
};

addressSchema.pre("save", async function (next) {
  const user = this;
  user.receiver_phone = normalizePhone(user.receiver_phone);
  next();
});

const Address = mongoose.model("Address", addressSchema);
module.exports = { Address, addressSchema };
