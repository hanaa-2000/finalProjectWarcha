class PaymentIntentModel {
  PaymentIntentModel({
    required this.id,
    required this.object,
    required this.amount,
    required this.amountCapturable,
    required this.amountDetails,
    required this.amountReceived,
    this.application,
    this.applicationFeeAmount,
    required this.automaticPaymentMethods,
    this.canceledAt,
    this.cancellationReason,
    required this.captureMethod,
    required this.clientSecret,
    required this.confirmationMethod,
    required this.created,
    required this.currency,
    this.customer,
    this.description,
    this.invoice,
    this.lastPaymentError,
    this.latestCharge,
    required this.livemode,
    required this.metadata,
    this.nextAction,
    this.onBehalfOf,
    this.paymentMethod,
    required this.paymentMethodOptions,
    required this.paymentMethodTypes,
    this.processing,
    this.receiptEmail,
    this.review,
    this.setupFutureUsage,
    this.shipping,
    this.source,
    this.statementDescriptor,
    this.statementDescriptorSuffix,
    required this.status,
    this.transferData,
    this.transferGroup,
  });
  late final String id;
  late final String object;
  late final int amount;
  late final int amountCapturable;
  late final AmountDetails amountDetails;
  late final int amountReceived;
  late final Null application;
  late final Null applicationFeeAmount;
  late final AutomaticPaymentMethods automaticPaymentMethods;
  late final Null canceledAt;
  late final Null cancellationReason;
  late final String captureMethod;
  late final String clientSecret;
  late final String confirmationMethod;
  late final int created;
  late final String currency;
  late final Null customer;
  late final Null description;
  late final Null invoice;
  late final Null lastPaymentError;
  late final Null latestCharge;
  late final bool livemode;
  late final Metadata metadata;
  late final Null nextAction;
  late final Null onBehalfOf;
  late final Null paymentMethod;
  late final PaymentMethodOptions paymentMethodOptions;
  late final List<String> paymentMethodTypes;
  late final Null processing;
  late final Null receiptEmail;
  late final Null review;
  late final Null setupFutureUsage;
  late final Null shipping;
  late final Null source;
  late final Null statementDescriptor;
  late final Null statementDescriptorSuffix;
  late final String status;
  late final Null transferData;
  late final Null transferGroup;

  PaymentIntentModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    object = json['object'];
    amount = json['amount'];
    amountCapturable = json['amount_capturable'];
    // amountDetails = AmountDetails.fromJson(json['amount_details']);
    amountReceived = json['amount_received'];
    application = null;
    applicationFeeAmount = null;
    // automaticPaymentMethods = AutomaticPaymentMethods.fromJson(json['automatic_payment_methods']);
    canceledAt = null;
    cancellationReason = null;
    captureMethod = json['capture_method'];
    clientSecret = json['client_secret'];
    confirmationMethod = json['confirmation_method'];
    created = json['created'];
    currency = json['currency'];
    customer = null;
    description = null;
    invoice = null;
    lastPaymentError = null;
    latestCharge = null;
    livemode = json['livemode'];
    // metadata = Metadata.fromJson(json['metadata']);
    nextAction = null;
    onBehalfOf = null;
    paymentMethod = null;
    // paymentMethodOptions = PaymentMethodOptions.fromJson(json['payment_method_options']);
    // paymentMethodTypes = List.castFrom<dynamic, String>(json['payment_method_types']);
    processing = null;
    receiptEmail = null;
    review = null;
    setupFutureUsage = null;
    shipping = null;
    source = null;
    statementDescriptor = null;
    statementDescriptorSuffix = null;
    status = json['status'];
    transferData = null;
    transferGroup = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['object'] = object;
    _data['amount'] = amount;
    _data['amount_capturable'] = amountCapturable;
    _data['amount_details'] = amountDetails.toJson();
    _data['amount_received'] = amountReceived;
    _data['application'] = application;
    _data['application_fee_amount'] = applicationFeeAmount;
    _data['automatic_payment_methods'] = automaticPaymentMethods.toJson();
    _data['canceled_at'] = canceledAt;
    _data['cancellation_reason'] = cancellationReason;
    _data['capture_method'] = captureMethod;
    _data['client_secret'] = clientSecret;
    _data['confirmation_method'] = confirmationMethod;
    _data['created'] = created;
    _data['currency'] = currency;
    _data['customer'] = customer;
    _data['description'] = description;
    _data['invoice'] = invoice;
    _data['last_payment_error'] = lastPaymentError;
    _data['latest_charge'] = latestCharge;
    _data['livemode'] = livemode;
    _data['metadata'] = metadata.toJson();
    _data['next_action'] = nextAction;
    _data['on_behalf_of'] = onBehalfOf;
    _data['payment_method'] = paymentMethod;
    _data['payment_method_options'] = paymentMethodOptions.toJson();
    _data['payment_method_types'] = paymentMethodTypes;
    _data['processing'] = processing;
    _data['receipt_email'] = receiptEmail;
    _data['review'] = review;
    _data['setup_future_usage'] = setupFutureUsage;
    _data['shipping'] = shipping;
    _data['source'] = source;
    _data['statement_descriptor'] = statementDescriptor;
    _data['statement_descriptor_suffix'] = statementDescriptorSuffix;
    _data['status'] = status;
    _data['transfer_data'] = transferData;
    _data['transfer_group'] = transferGroup;
    return _data;
  }
}

class AmountDetails {
  AmountDetails({
    required this.tip,
  });
  late final Tip tip;

  AmountDetails.fromJson(Map<String, dynamic> json){
    tip = Tip.fromJson(json['tip']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['tip'] = tip.toJson();
    return _data;
  }
}

class Tip {
  Tip();

  Tip.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}

class AutomaticPaymentMethods {
  AutomaticPaymentMethods({
    required this.enabled,
  });
  late final bool enabled;

  AutomaticPaymentMethods.fromJson(Map<String, dynamic> json){
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['enabled'] = enabled;
    return _data;
  }
}

class Metadata {
  Metadata();

  Metadata.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}

class PaymentMethodOptions {
  PaymentMethodOptions({
    required this.card,
    required this.link,
  });
  late final Card card;
  late final Link link;

  PaymentMethodOptions.fromJson(Map<String, dynamic> json){
    card = Card.fromJson(json['card']);
    link = Link.fromJson(json['link']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['card'] = card.toJson();
    _data['link'] = link.toJson();
    return _data;
  }
}

class Card {
  Card({
    this.installments,
    this.mandateOptions,
    this.network,
    required this.requestThreeDSecure,
  });
  late final Null installments;
  late final Null mandateOptions;
  late final Null network;
  late final String requestThreeDSecure;

  Card.fromJson(Map<String, dynamic> json){
    installments = null;
    mandateOptions = null;
    network = null;
    requestThreeDSecure = json['request_three_d_secure'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['installments'] = installments;
    _data['mandate_options'] = mandateOptions;
    _data['network'] = network;
    _data['request_three_d_secure'] = requestThreeDSecure;
    return _data;
  }
}

class Link {
  Link({
    this.persistentToken,
  });
  late final Null persistentToken;

  Link.fromJson(Map<String, dynamic> json){
    persistentToken = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['persistent_token'] = persistentToken;
    return _data;
  }
}