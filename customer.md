<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order Online</title>
<style>
  :root{
    /* Palette sampled directly from the Con Vista logo — see con-vista-design-system.md */
    --brand-primary:#FF741F;        /* logo cocktail-glass orange */
    --brand-primary-dark:#CC5C19;   /* pressed state */
    --brand-green:#16A34A;          /* logo neon-ring green */
    --brand-mint:#E3F5E0;           /* soft green badge fill */
    --brand-black:#000000;          /* logo background */
    --brand-dark:#1c1917;
    --brand-bg:#fafaf9;
    --brand-card:#ffffff;
    --brand-border:#e7e5e4;
    --brand-muted:#78716c;
    --brand-disabled-bg:#F1F0EE;
    --brand-disabled-text:#A8A29E;
    --radius:14px;
  }
  *{ box-sizing:border-box; -webkit-tap-highlight-color:transparent; }
  /* Single source of truth for hiding elements — every other rule below that
     hides a specific #id.hidden or .class.hidden is now redundant but kept
     for clarity; this generic rule is what actually guarantees it works. */
  .hidden{ display:none !important; }
  body{ margin:0; font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif; background:var(--brand-bg); color:var(--brand-dark); padding-bottom:96px; }
  button{ font-family:inherit; cursor:pointer; border:none; }
  h1,h2,p{ margin:0; }

  /* Header */
  header{ position:sticky; top:0; z-index:20; background:var(--brand-black); box-shadow:0 1px 6px rgba(0,0,0,.35); padding:14px 16px; }
  .header-inner{ display:flex; align-items:center; gap:12px; }
  .header-logo{ width:44px; height:44px; border-radius:50%; object-fit:cover; flex-shrink:0; }
  header h1{ font-size:20px; font-weight:700; color:#fff; }
  header p{ font-size:12px; color:#a8a29e; margin-top:2px; }

  /* Category nav */
  #categoryNav{ display:flex; gap:8px; overflow-x:auto; padding:12px 16px; background:#fff; border-bottom:1px solid var(--brand-border); scrollbar-width:none; }
  #categoryNav::-webkit-scrollbar{ display:none; }
  .cat-chip{ white-space:nowrap; padding:8px 16px; border-radius:999px; font-size:14px; font-weight:600; border:1px solid var(--brand-border); background:#fff; color:var(--brand-muted); flex-shrink:0; }
  .cat-chip.active{ background:var(--brand-primary); color:#fff; border-color:var(--brand-primary); }

  /* Menu */
  main{ padding:16px; display:flex; flex-direction:column; gap:24px; }
  .section-title{ font-size:18px; font-weight:700; margin-bottom:8px; }
  .item-list{ display:flex; flex-direction:column; gap:8px; }
  .item-card{ background:var(--brand-card); border-radius:12px; box-shadow:0 1px 2px rgba(0,0,0,.04); padding:12px; display:flex; justify-content:space-between; align-items:center; }
  .item-card.sold-out{ background:var(--brand-disabled-bg); box-shadow:none; }
  .item-card.sold-out .item-price{ color:var(--brand-disabled-text); }
  .sold-out-badge{ background:#fff; color:var(--brand-disabled-text); font-size:11px; font-weight:700; border-radius:999px; padding:5px 12px; flex-shrink:0; white-space:nowrap; border:1px solid var(--brand-border); }
  .item-info{ padding-right:12px; }
  .item-name{ font-weight:600; font-size:15px; }
  .item-desc{ font-size:12px; color:var(--brand-muted); margin-top:2px; }
  .item-price{ font-weight:700; font-size:14px; color:var(--brand-primary); margin-top:4px; }
  .add-btn{ background:var(--brand-primary); color:#fff; width:40px; height:40px; border-radius:999px; font-size:20px; font-weight:700; flex-shrink:0; }
  .stepper{ display:flex; align-items:center; gap:6px; background:#f5f5f4; border-radius:999px; padding:4px; flex-shrink:0; }
  .qty-btn{ width:30px; height:30px; border-radius:999px; font-weight:700; font-size:16px; background:#fff; box-shadow:0 1px 2px rgba(0,0,0,.1); }
  .qty-btn.plus{ background:var(--brand-primary); color:#fff; }
  .qty-val{ min-width:16px; text-align:center; font-weight:700; font-size:14px; }
  .qty-control{ display:flex; flex-direction:column; align-items:center; gap:4px; flex-shrink:0; }
  .qty-badge{ font-size:11px; font-weight:600; color:var(--brand-primary); white-space:nowrap; }
  .add-btn:active{ background:var(--brand-primary-dark); }

  /* Cart bar */
  #cartBar{ position:fixed; bottom:0; left:0; right:0; background:var(--brand-primary); color:#fff; padding:16px; display:flex; justify-content:space-between; align-items:center; box-shadow:0 -2px 10px rgba(0,0,0,.15); }
  #cartBar.hidden{ display:none; }
  #cartInfo{ font-weight:600; }
  #cartBar button{ background:#fff; color:var(--brand-primary); font-weight:700; padding:10px 16px; border-radius:10px; }

  /* Checkout modal */
  #checkoutModal{ position:fixed; inset:0; background:rgba(0,0,0,.5); z-index:30; display:flex; align-items:flex-end; }
  #flavorModal{ position:fixed; inset:0; background:rgba(0,0,0,.5); z-index:35; display:flex; align-items:flex-end; }
  #confirmFlavorBtn{ width:100%; background:var(--brand-primary); color:#fff; font-weight:700; padding:14px; border-radius:12px; font-size:16px; margin-top:6px; }
  #checkoutModal.hidden{ display:none; }
  #checkoutModal .sheet, #flavorModal .sheet{ background:#fff; width:100%; border-radius:20px 20px 0 0; padding:20px; max-height:85vh; overflow-y:auto; }
  .sheet-header{ display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; }
  .sheet-header h2{ font-size:18px; font-weight:700; }
  .sheet-close{ background:none; color:#a8a29e; font-size:20px; }
  .field-label{ font-weight:600; margin-bottom:8px; display:block; }
  .checkout-items-box{ background:#fafaf9; border:1px solid var(--brand-border); border-radius:10px; padding:10px 12px; margin-bottom:16px; }
  .checkout-item-row{ display:flex; justify-content:space-between; font-size:14px; padding:4px 0; }
  .checkout-item-row + .checkout-item-row{ border-top:1px solid var(--brand-border); }
  .checkout-item-right{ display:flex; align-items:center; gap:8px; }
  .remove-line-btn{ background:#f0efee; color:var(--brand-muted); width:22px; height:22px; border-radius:999px; font-weight:700; font-size:14px; line-height:1; }
  .empty-cart-note{ font-size:13px; color:var(--brand-muted); text-align:center; padding:8px 0; }
  .choice-grid{ display:grid; gap:8px; margin-bottom:16px; }
  .choice-grid.grid-3{ grid-template-columns:1fr 1fr 1fr; }
  .choice-grid.grid-2{ grid-template-columns:1fr 1fr; }
  .choice-btn{ border:1px solid var(--brand-border); border-radius:10px; padding:10px; font-size:14px; font-weight:600; background:#fff; color:var(--brand-dark); }
  .choice-btn.selected{ background:var(--brand-primary); color:#fff; border-color:var(--brand-primary); }
  .subtotal-row{ display:flex; justify-content:space-between; font-size:14px; color:var(--brand-muted); padding:2px 0; }
  .subtotal-row.hidden{ display:none; }
  .total-row{ border-top:1px solid var(--brand-border); padding-top:8px; margin-top:6px; margin-bottom:16px; display:flex; justify-content:space-between; font-weight:700; font-size:18px; }
  #checkoutError{ color:#dc2626; font-size:14px; margin-bottom:8px; display:none; }
  #checkoutError.visible{ display:block; }
  #placeOrderBtn{ width:100%; background:var(--brand-primary); color:#fff; font-weight:700; padding:14px; border-radius:12px; font-size:16px; }
  #placeOrderBtn:disabled{ opacity:.6; }

  /* Receipt view */
  .receipt-check{ font-size:40px; text-align:center; margin-bottom:4px; }
  .receipt-heading{ font-size:19px; font-weight:700; text-align:center; }
  .receipt-sub{ font-size:13px; color:var(--brand-muted); text-align:center; margin-top:2px; margin-bottom:16px; }
  .receipt-box{ background:#fafaf9; border:1px dashed var(--brand-border); border-radius:12px; padding:14px; margin-bottom:14px; }
  .receipt-row{ display:flex; justify-content:space-between; font-size:13px; padding:3px 0; }
  .receipt-row.hidden{ display:none; }
  .receipt-strong{ font-weight:700; color:var(--brand-primary); }
  .receipt-divider{ border-top:1px dashed var(--brand-border); margin:8px 0; }
  .receipt-total{ font-weight:700; font-size:15px; margin-top:4px; }
  .receipt-note{ font-size:13px; color:var(--brand-muted); text-align:center; line-height:1.5; margin-bottom:12px; }
  #receiptDoneBtn{ width:100%; background:var(--brand-primary); color:#fff; font-weight:700; padding:14px; border-radius:12px; font-size:16px; }
  #receiptDoneBtn:disabled{ opacity:.4; }
  .receipt-save-instruction{ text-align:center; font-size:13px; font-weight:600; color:var(--brand-primary); margin-bottom:8px; }
  #saveReceiptBtn{ width:100%; background:var(--brand-dark); color:#fff; font-weight:700; padding:14px; border-radius:12px; font-size:16px; margin-bottom:10px; }
  #saveReceiptStatus.hidden{ display:none; }
  #saveReceiptStatus{ font-size:12px; margin-bottom:10px; }
  #alreadySavedLink{ display:block; width:100%; background:none; color:var(--brand-muted); font-size:12px; text-decoration:underline; padding:8px; margin-top:6px; }
</style>
</head>
<body>

  <!-- Header -->
  <header>
    <div class="header-inner">
      <img class="header-logo" alt="Con Vista Cafe and Dining logo" src="data:image/jpeg;base64,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">
      <div>
        <h1>Con Vista Cafe and Dining</h1>
        <p>Tap items to add to your order</p>
      </div>
    </div>
  </header>

  <!-- Category chips -->
  <div id="categoryNav"></div>

  <!-- Menu -->
  <main id="menu"></main>

  <!-- Fixed bottom cart bar -->
  <div id="cartBar" class="hidden">
    <span id="cartInfo">0 items · ₱0.00</span>
    <button onclick="openCheckout()">Checkout</button>
  </div>

  <!-- Checkout modal -->
  <div id="checkoutModal" class="hidden">
    <div class="sheet">
      <div class="sheet-header">
        <h2 id="sheetTitle">Checkout</h2>
        <button onclick="handleCloseTap()" class="sheet-close">✕</button>
      </div>

      <div id="checkoutForm">
        <label class="field-label">Your Order</label>
        <div id="checkoutItemsSummary" class="checkout-items-box"></div>

        <label class="field-label">Order Type</label>
        <div class="choice-grid grid-3" id="orderTypeGroup">
          <button data-value="dine-in" onclick="selectOrderType(this)" class="order-type-btn choice-btn">Dine-In</button>
          <button data-value="takeout" onclick="selectOrderType(this)" class="order-type-btn choice-btn">Take-Out</button>
          <button data-value="pickup" onclick="selectOrderType(this)" class="order-type-btn choice-btn">Pick-Up</button>
        </div>

        <label class="field-label">Payment Method</label>
        <div class="choice-grid grid-2" id="paymentGroup">
          <button data-value="Cash" onclick="selectPayment(this)" class="payment-btn choice-btn">Cash</button>
          <button data-value="GCash" onclick="selectPayment(this)" class="payment-btn choice-btn">GCash</button>
          <button data-value="Online Banking" onclick="selectPayment(this)" class="payment-btn choice-btn">Online Banking</button>
          <button data-value="Credit Card" onclick="selectPayment(this)" class="payment-btn choice-btn">Credit Card</button>
        </div>

        <div class="subtotal-row">
          <span>Subtotal</span>
          <span id="checkoutSubtotal">₱0.00</span>
        </div>
        <div class="subtotal-row hidden" id="serviceChargeRow">
          <span>Service Charge</span>
          <span id="checkoutServiceCharge">₱0.00</span>
        </div>
        <div class="total-row">
          <span>Total</span>
          <span id="checkoutTotal">₱0.00</span>
        </div>

        <p id="checkoutError"></p>

        <button onclick="placeOrder()" id="placeOrderBtn">Place Order</button>
      </div>

      <!-- Receipt view — shown after a successful order, replaces the form above -->
      <div id="receiptView" class="hidden">
        <div class="receipt-check">✅</div>
        <p class="receipt-heading">Order Received!</p>
        <p class="receipt-sub">Thank you for ordering with us.</p>

        <div class="receipt-box">
          <div class="receipt-row"><span>Order No.</span><span id="rcptOrderNo" class="receipt-strong"></span></div>
          <div class="receipt-row"><span>Date &amp; Time</span><span id="rcptDateTime"></span></div>
          <div class="receipt-row"><span>Location</span><span>Con Vista Antipolo</span></div>
          <div class="receipt-row"><span>Order Type</span><span id="rcptOrderType"></span></div>

          <div class="receipt-divider"></div>
          <div id="rcptItems"></div>
          <div class="receipt-divider"></div>

          <div class="receipt-row"><span>Subtotal</span><span id="rcptSubtotal"></span></div>
          <div class="receipt-row hidden" id="rcptServiceChargeRow"><span>Service Charge</span><span id="rcptServiceCharge"></span></div>
          <div class="receipt-row receipt-total"><span>Total</span><span id="rcptTotal"></span></div>
        </div>

        <p id="rcptPaymentNote" class="receipt-note"></p>
        <p class="receipt-note">Sit back and relax! Feel free to borrow any of our tabletop games while you wait for your food or drinks to be served.</p>

        <p class="receipt-save-instruction">Please save your receipt before continuing</p>
        <button onclick="saveReceiptImage()" id="saveReceiptBtn">📥 Save Receipt to Photos</button>
        <p id="saveReceiptStatus" class="receipt-note hidden"></p>

        <button onclick="closeCheckout()" id="receiptDoneBtn" disabled>Done</button>
        <button onclick="confirmSkipSave()" id="alreadySavedLink">I already took a screenshot — continue</button>
      </div>
    </div>
  </div>

  <!-- Flavor / variant picker — opens when tapping + on an item that has options -->
  <div id="flavorModal" class="hidden">
    <div class="sheet">
      <div class="sheet-header">
        <h2 id="flavorModalTitle">Choose Flavor</h2>
        <button onclick="closeFlavorModal()" class="sheet-close">✕</button>
      </div>
      <label class="field-label" id="flavorModalLabel">Flavor</label>
      <div class="choice-grid grid-2" id="flavorChoices"></div>
      <button onclick="confirmAddFlavorItem()" id="confirmFlavorBtn">Add to Cart</button>
    </div>
  </div>


<script>
  /* ======================================================================
     MENU DATA — embedded directly from your menu_items export.
     No network call, no Supabase, needed to show the menu at all.
     To edit prices/items later: just edit this array directly.
     ====================================================================== */
  const MENU_ITEMS = [
    { id: 'ap01', category: 'Appetizers', name: 'Fries', description: 'Perfect to share.', price: 159.0 },
    { id: 'ap02', category: 'Appetizers', name: 'Chicken Fingers', description: 'Perfect to share.', price: 159.0 },
    { id: 'ap03', category: 'Appetizers', name: 'Fried Enoki', description: 'Perfect to share.', price: 169.0 },
    { id: 'ap04', category: 'Appetizers', name: 'Chicken Chops', description: 'Perfect to share.', price: 169.0 },
    { id: 'ap05', category: 'Appetizers', name: 'Chicken Pops', description: 'Perfect to share.', price: 179.0 },
    { id: 'ap06', category: 'Appetizers', name: 'Fries Overload', description: 'Perfect to share.', price: 189.0 },
    { id: 'ap07', category: 'Appetizers', name: 'Sizzling Tofu', description: 'Perfect to share.', price: 199.0 },
    { id: 'ap08', category: 'Appetizers', name: 'Sizzling TJ Hotdog', description: 'Perfect to share.', price: 199.0 },
    { id: 'ap09', category: 'Appetizers', name: 'Sizzling Corn', description: 'Perfect to share.', price: 199.0 },
    { id: 'ap10', category: 'Appetizers', name: 'Lumpiang Shanghai', description: 'Perfect to share.', price: 199.0 },
    { id: 'ap11', category: 'Appetizers', name: 'Home-made Cheese Sticks', description: 'Perfect to share.', price: 229.0 },
    { id: 'ap12', category: 'Appetizers', name: 'Fish and Chips', description: 'Perfect to share.', price: 229.0 },
    { id: 'ap13', category: 'Appetizers', name: 'Tuna Sisig', description: 'Perfect to share.', price: 229.0 },
    { id: 'ap14', category: 'Appetizers', name: 'Tofu Squares', description: 'Perfect to share.', price: 259.0 },
    { id: 'ap15', category: 'Appetizers', name: 'Hot Cheezy Dynamite', description: 'Perfect to share.', price: 269.0 },
    { id: 'ap16', category: 'Appetizers', name: 'Calamares Crisp', description: 'Perfect to share.', price: 269.0 },
    { id: 'ap17', category: 'Appetizers', name: 'Tokwa\'t Baboy', description: 'Perfect to share.', price: 279.0 },
    { id: 'ap18', category: 'Appetizers', name: 'Nachos Overload', description: 'Perfect to share.', price: 279.0 },
    { id: 'ap19', category: 'Appetizers', name: 'Crispy Salmon Belly', description: 'Perfect to share.', price: 279.0 },
    { id: 'ap20', category: 'Appetizers', name: 'Wings & Wedge', description: 'Perfect to share.', price: 349.0 },
    { id: 'be01', category: 'Cocktails and Beers', name: 'San Mig Light', description: '', price: 90.0 },
    { id: 'be02', category: 'Cocktails and Beers', name: 'San Mig Apple', description: '', price: 90.0 },
    { id: 'be03', category: 'Cocktails and Beers', name: 'Pale Pilsen', description: '', price: 90.0 },
    { id: 'be04', category: 'Cocktails and Beers', name: 'Red Horse (350ml)', description: '', price: 90.0 },
    { id: 'be05', category: 'Cocktails and Beers', name: 'Red Horse (500ml)', description: '', price: 120.0 },
    { id: 'be06', category: 'Cocktails and Beers', name: 'Corona', description: '', price: 150.0 },
    { id: 'be07', category: 'Cocktails and Beers', name: 'Heineken', description: '', price: 150.0 },
    { id: 'be08', category: 'Cocktails and Beers', name: 'Beer Bucket', description: 'Save ₱40 vs buying individually.', price: 500.0 },
    { id: 'bf01', category: 'All-Day Breakfast', name: 'Continental Breakfast', description: 'Hungarian sausage, bacon, egg, toasted bread with fresh sides.', price: 249.0 },
    { id: 'bf02', category: 'All-Day Breakfast', name: 'Con Vista Breakfast', description: 'Hungarian sausage, bacon strips, 2 eggs, 2 hashbrowns, toasted bread with fresh sides.', price: 289.0 },
    { id: 'cc01', category: 'Classic Coffees', name: 'Cafe Latte', description: 'Iced, 16oz.', price: 170.0 },
    { id: 'cc02', category: 'Classic Coffees', name: 'White Chocolate Mocha', description: 'Iced, 16oz.', price: 189.0 },
    { id: 'cc03', category: 'Classic Coffees', name: 'Cappuccino', description: 'Iced, 16oz.', price: 170.0 },
    { id: 'cc04', category: 'Classic Coffees', name: 'Caramel Macchiato', description: 'Iced, 16oz.', price: 170.0 },
    { id: 'cc05', category: 'Classic Coffees', name: 'Spanish Latte', description: 'Iced, 16oz.', price: 170.0 },
    { id: 'cc06', category: 'Classic Coffees', name: 'Biscoff', description: 'Iced, 16oz.', price: 199.0 },
    { id: 'cc07', category: 'Classic Coffees', name: 'Americano', description: 'Iced, 16oz.', price: 140.0 },
    { id: 'cc08', category: 'Classic Coffees', name: 'Hazelnut', description: 'Iced, 16oz.', price: 170.0 },
    { id: 'cc09', category: 'Classic Coffees', name: 'Caramel Latte', description: 'Iced, 16oz.', price: 170.0 },
    { id: 'cc10', category: 'Classic Coffees', name: 'Salted Caramel', description: 'Iced, 16oz.', price: 170.0 },
    { id: 'cc11', category: 'Classic Coffees', name: 'Dalgona', description: 'Iced, 16oz.', price: 189.0 },
    { id: 'cc12', category: 'Classic Coffees', name: 'Vietnamese', description: 'Iced, 16oz.', price: 170.0 },
    { id: 'cc13', category: 'Classic Coffees', name: 'Cafe Mocha', description: 'Iced, 16oz.', price: 170.0 },
    { id: 'cc14', category: 'Classic Coffees', name: 'Brown Sugar Vanilla', description: 'Iced, 16oz.', price: 170.0 },
    { id: 'cc15', category: 'Classic Coffees', name: 'Sea Salt', description: 'Iced, 16oz.', price: 170.0 },
    { id: 'cf01', category: 'Cafe Frappe', name: 'Biscoff Frappe (Non-Coffee)', description: 'Blended to perfection.', price: 210.0 },
    { id: 'cf02', category: 'Cafe Frappe', name: 'Biscoff Frappe (Coffee-Based)', description: 'Blended to perfection.', price: 230.0 },
    { id: 'cf03', category: 'Cafe Frappe', name: 'Strawberry Frappe (Non-Coffee)', description: 'Blended to perfection.', price: 189.0 },
    { id: 'cf04', category: 'Cafe Frappe', name: 'Strawberry Frappe (Coffee-Based)', description: 'Blended to perfection.', price: 210.0 },
    { id: 'cf05', category: 'Cafe Frappe', name: 'Caramel Frappe (Non-Coffee)', description: 'Blended to perfection.', price: 189.0 },
    { id: 'cf06', category: 'Cafe Frappe', name: 'Caramel Frappe (Coffee-Based)', description: 'Blended to perfection.', price: 210.0 },
    { id: 'cf07', category: 'Cafe Frappe', name: 'Hazelnut Frappe (Non-Coffee)', description: 'Blended to perfection.', price: 189.0 },
    { id: 'cf08', category: 'Cafe Frappe', name: 'Hazelnut Frappe (Coffee-Based)', description: 'Blended to perfection.', price: 210.0 },
    { id: 'cf09', category: 'Cafe Frappe', name: 'Mocha Frappe (Non-Coffee)', description: 'Blended to perfection.', price: 189.0 },
    { id: 'cf10', category: 'Cafe Frappe', name: 'Mocha Frappe (Coffee-Based)', description: 'Blended to perfection.', price: 210.0 },
    { id: 'cf11', category: 'Cafe Frappe', name: 'Salted Caramel Frappe (Non-Coffee)', description: 'Blended to perfection.', price: 189.0 },
    { id: 'cf12', category: 'Cafe Frappe', name: 'Salted Caramel Frappe (Coffee-Based)', description: 'Blended to perfection.', price: 210.0 },
    { id: 'cf13', category: 'Cafe Frappe', name: 'Java Chip Frappe (Non-Coffee)', description: 'Blended to perfection.', price: 189.0 },
    { id: 'cf14', category: 'Cafe Frappe', name: 'Java Chip Frappe (Coffee-Based)', description: 'Blended to perfection.', price: 210.0 },
    { id: 'cf15', category: 'Cafe Frappe', name: 'Cookies & Cream Frappe (Non-Coffee)', description: 'Blended to perfection.', price: 189.0 },
    { id: 'cf16', category: 'Cafe Frappe', name: 'Cookies & Cream Frappe (Coffee-Based)', description: 'Blended to perfection.', price: 210.0 },
    { id: 'cf17', category: 'Cafe Frappe', name: 'Choco Drop Frappe (Non-Coffee)', description: 'Blended to perfection.', price: 189.0 },
    { id: 'cf18', category: 'Cafe Frappe', name: 'Choco Drop Frappe (Coffee-Based)', description: 'Blended to perfection.', price: 210.0 },
    { id: 'cf19', category: 'Cafe Frappe', name: 'Ube Frappe (Non-Coffee)', description: 'Blended to perfection.', price: 189.0 },
    { id: 'cf20', category: 'Cafe Frappe', name: 'Ube Frappe (Coffee-Based)', description: 'Blended to perfection.', price: 210.0 },
    { id: 'ck01', category: 'Cocktails and Beers', name: 'Margarita', description: 'Crafted fresh at the bar.', price: 209.0 },
    { id: 'ck02', category: 'Cocktails and Beers', name: 'Tequila Sunrise', description: 'Crafted fresh at the bar.', price: 189.0 },
    { id: 'ck03', category: 'Cocktails and Beers', name: 'Malibu Sunset', description: 'Crafted fresh at the bar.', price: 209.0 },
    { id: 'ck04', category: 'Cocktails and Beers', name: 'Classic Daiquiri', description: 'Crafted fresh at the bar.', price: 209.0 },
    { id: 'ck05', category: 'Cocktails and Beers', name: 'Espresso Martini', description: 'Crafted fresh at the bar.', price: 230.0 },
    { id: 'ck06', category: 'Cocktails and Beers', name: 'Mojito', description: 'Crafted fresh at the bar.', price: 189.0 },
    { id: 'ck07', category: 'Cocktails and Beers', name: 'Gin Tonic', description: 'Crafted fresh at the bar.', price: 230.0 },
    { id: 'd1', category: 'Desserts', name: 'Basque Burnt Cheesecake', description: 'Slice, caramelized top.', price: 145.0 },
    { id: 'd2', category: 'Desserts', name: 'Ube Halaya Tart', description: 'Purple yam custard tart.', price: 135.0 },
    { id: 'de01', category: 'Desserts', name: 'Leche Flan (Small)', description: 'Sweet ending, perfect day.', price: 80.0 },
    { id: 'de02', category: 'Desserts', name: 'Leche Flan (Big)', description: 'Sweet ending, perfect day.', price: 160.0 },
    { id: 'de03', category: 'Desserts', name: 'Banana Split', description: 'Sweet ending, perfect day.', price: 250.0 },
    { id: 'f1', category: 'All-Day Breakfast', name: 'Vista Breakfast Plate', description: 'Longsilog with garlic rice and egg.', price: 220.0 },
    { id: 'hc01', category: 'Classic Coffees', name: 'Americano (Hot)', description: 'Hot.', price: 109.0 },
    { id: 'hc02', category: 'Classic Coffees', name: 'Cappuccino (Hot)', description: 'Hot.', price: 130.0 },
    { id: 'hc03', category: 'Classic Coffees', name: 'Vietnamese (Hot)', description: 'Hot.', price: 130.0 },
    { id: 'hc04', category: 'Classic Coffees', name: 'Cafe Latte (Hot)', description: 'Hot.', price: 130.0 },
    { id: 'hc05', category: 'Classic Coffees', name: 'Spanish Latte (Hot)', description: 'Hot.', price: 130.0 },
    { id: 'hc06', category: 'Classic Coffees', name: 'Salted Caramel (Hot)', description: 'Hot.', price: 130.0 },
    { id: 'hc07', category: 'Classic Coffees', name: 'Caramel Latte (Hot)', description: 'Hot.', price: 130.0 },
    { id: 'hc08', category: 'Classic Coffees', name: 'Cafe Mocha (Hot)', description: 'Hot.', price: 130.0 },
    { id: 'hc09', category: 'Classic Coffees', name: 'Caramel Macchiato (Hot)', description: 'Hot.', price: 130.0 },
    { id: 'hc10', category: 'Classic Coffees', name: 'Brown Sugar Vanilla (Hot)', description: 'Hot.', price: 130.0 },
    { id: 'hc11', category: 'Classic Coffees', name: 'White Choco Mocha (Hot)', description: 'Hot.', price: 130.0 },
    { id: 'hc12', category: 'Classic Coffees', name: 'Hazelnut Latte (Hot)', description: 'Hot.', price: 130.0 },
    { id: 'hc13', category: 'Classic Coffees', name: 'Dirty Matcha (Hot)', description: 'Hot.', price: 150.0 },
    { id: 'hc14', category: 'Classic Coffees', name: 'Biscoff Latte (Hot, Coffee-Based)', description: 'Hot.', price: 150.0 },
    { id: 'hn01', category: 'Non-Coffee Drinks', name: 'Matcha Latte (Hot)', description: 'Hot.', price: 130.0 },
    { id: 'hn02', category: 'Non-Coffee Drinks', name: 'Biscoff Latte (Hot, Non-Coffee)', description: 'Hot.', price: 150.0 },
    { id: 'hn03', category: 'Non-Coffee Drinks', name: 'Tsokolate de Batirol (Hot)', description: 'Hot.', price: 170.0 },
    { id: 'hn04', category: 'Non-Coffee Drinks', name: 'Chamomile Tea (Hot)', description: 'Hot.', price: 80.0 },
    { id: 'ktv1', category: 'KTV Packages', name: 'CV1 Package', description: 'Up to 10 pax, 2 hrs, KTV Cabin 3. 20 bottles of beer or 2x 3L cocktail towers, pork sisig, chicken wings, calamares crisp.', price: 4520.0 },
    { id: 'ktv2', category: 'KTV Packages', name: 'CV2 Package', description: 'Up to 10 pax, 2 hrs. 20 bottles of beer or 2x 3L towers, chicken wings, crispy pata, calamares, nachos overload, pork sisig, pancit.', price: 6250.0 },
    { id: 'ktv3', category: 'KTV Packages', name: 'CV3 Package', description: 'Up to 15 pax, 2 hrs. 30 bottles of beer or 3x 3L towers, chicken wings, crispy pata, calamares, nachos overload, 2x pork sisig, tokwat baboy, sizzling hotdog, pancit.', price: 9250.0 },
    { id: 'me01', category: 'Matcha Edition', name: 'Spanish Matcha', description: 'Creamy & smooth classic matcha.', price: 170.0 },
    { id: 'me02', category: 'Matcha Edition', name: 'Strawberry Matcha', description: 'Sweet strawberry meets premium matcha.', price: 189.0 },
    { id: 'me03', category: 'Matcha Edition', name: 'Dirty Matcha', description: 'Bold matcha with a shot of espresso.', price: 199.0 },
    { id: 'me04', category: 'Matcha Edition', name: 'Matcha Latte', description: 'Smooth, milky, matcha perfection.', price: 170.0 },
    { id: 'me05', category: 'Matcha Edition', name: 'Matcha Frappe', description: 'Blended, creamy & refreshing.', price: 210.0 },
    { id: 'me06', category: 'Matcha Edition', name: 'Blueberry Matcha', description: 'Tangy blueberry with smooth matcha.', price: 189.0 },
    { id: 'me07', category: 'Matcha Edition', name: 'Ube Matcha', description: 'Creamy ube & earthy matcha.', price: 189.0 },
    { id: 'me08', category: 'Matcha Edition', name: 'Choco Matcha', description: 'Rich chocolate & matcha blend.', price: 189.0 },
    { id: 'me09', category: 'Matcha Edition', name: 'Sea Salt Matcha', description: 'A hint of sea salt for the perfect balance.', price: 189.0 },
    { id: 'me10', category: 'Matcha Edition', name: 'Dirty Matcha Frappe', description: 'Matcha frappe with a shot of espresso.', price: 230.0 },
    { id: 'nc01', category: 'Non-Coffee Drinks', name: 'Ube Cream', description: 'Milk Series — creamy, flavorful, irresistible.', price: 199.0 },
    { id: 'nc02', category: 'Non-Coffee Drinks', name: 'Biscoff Bliss', description: 'Milk Series — creamy, flavorful, irresistible.', price: 199.0 },
    { id: 'nc03', category: 'Non-Coffee Drinks', name: 'Milo Rawr', description: 'Milk Series — creamy, flavorful, irresistible.', price: 199.0 },
    { id: 'nc04', category: 'Non-Coffee Drinks', name: 'Agua de Fresa (Strawberry)', description: 'Milk Series — creamy, flavorful, irresistible.', price: 199.0 },
    { id: 'nc05', category: 'Non-Coffee Drinks', name: 'Hershey\'s Choco', description: 'Milk Series — creamy, flavorful, irresistible.', price: 199.0 },
    { id: 'nc06', category: 'Non-Coffee Drinks', name: 'Nutella Dream', description: 'Milk Series — creamy, flavorful, irresistible.', price: 199.0 },
    { id: 'nc07', category: 'Non-Coffee Drinks', name: 'Greenapple Fruit Tea', description: 'Fruit Tea Refresher.', price: 125.0 },
    { id: 'nc08', category: 'Non-Coffee Drinks', name: 'Blueberry Fruit Tea', description: 'Fruit Tea Refresher.', price: 125.0 },
    { id: 'nc09', category: 'Non-Coffee Drinks', name: 'Four Seasons Fruit Tea', description: 'Fruit Tea Refresher.', price: 125.0 },
    { id: 'nc10', category: 'Non-Coffee Drinks', name: 'Mango Fruit Tea', description: 'Fruit Tea Refresher.', price: 125.0 },
    { id: 'nc11', category: 'Non-Coffee Drinks', name: 'Honeydew Fruit Tea', description: 'Fruit Tea Refresher.', price: 125.0 },
    { id: 'nc12', category: 'Non-Coffee Drinks', name: 'Lychee Fruit Tea', description: 'Fruit Tea Refresher.', price: 125.0 },
    { id: 'nc13', category: 'Non-Coffee Drinks', name: 'Strawberry Fruit Tea', description: 'Fruit Tea Refresher.', price: 125.0 },
    { id: 'nc14', category: 'Non-Coffee Drinks', name: 'Greenapple Fruit Soda', description: 'Fizzy, fruity, refreshing.', price: 140.0 },
    { id: 'nc15', category: 'Non-Coffee Drinks', name: 'Blueberry Fruit Soda', description: 'Fizzy, fruity, refreshing.', price: 140.0 },
    { id: 'nc16', category: 'Non-Coffee Drinks', name: 'Four Seasons Fruit Soda', description: 'Fizzy, fruity, refreshing.', price: 140.0 },
    { id: 'nc17', category: 'Non-Coffee Drinks', name: 'Mango Fruit Soda', description: 'Fizzy, fruity, refreshing.', price: 140.0 },
    { id: 'nc18', category: 'Non-Coffee Drinks', name: 'Honeydew Fruit Soda', description: 'Fizzy, fruity, refreshing.', price: 140.0 },
    { id: 'nc19', category: 'Non-Coffee Drinks', name: 'Lychee Fruit Soda', description: 'Fizzy, fruity, refreshing.', price: 140.0 },
    { id: 'nc20', category: 'Non-Coffee Drinks', name: 'Strawberry Fruit Soda', description: 'Fizzy, fruity, refreshing.', price: 140.0 },
    { id: 'od01', category: 'Other Drinks', name: 'Bottled Water 500ml', description: '', price: 35.0 },
    { id: 'od02', category: 'Other Drinks', name: 'Iced Tea (Glass)', description: '', price: 70.0 },
    { id: 'od03', category: 'Other Drinks', name: 'Iced Tea (Pitcher)', description: '', price: 120.0 },
    { id: 'od04', category: 'Other Drinks', name: 'Coke / Sprite / Royal (Mismo)', description: '', price: 35.0 },
    { id: 'od05', category: 'Other Drinks', name: 'Coke / Sprite / Royal 1.5L', description: '', price: 140.0 },
    { id: 'pc01', category: 'Pancit', name: 'Pancit Bihon', description: '', price: 300.0 },
    { id: 'pc02', category: 'Pancit', name: 'Pancit Canton', description: '', price: 300.0 },
    { id: 'pc03', category: 'Pancit', name: 'Pancit Mixed (Bihon and Canton)', description: '', price: 300.0 },
    { id: 'pd01', category: 'Pinoy Dishes (For Sharing)', name: 'Beef Caldereta', description: 'Made with love, made for you.', price: 399.0 },
    { id: 'pd02', category: 'Pinoy Dishes (For Sharing)', name: 'Pork Binagoongan', description: 'Made with love, made for you.', price: 399.0 },
    { id: 'pd03', category: 'Pinoy Dishes (For Sharing)', name: 'Crispy Kare-Kare', description: 'Made with love, made for you.', price: 419.0 },
    { id: 'pd04', category: 'Pinoy Dishes (For Sharing)', name: 'Pork Sisig', description: 'Made with love, made for you.', price: 389.0 },
    { id: 'pd05', category: 'Pinoy Dishes (For Sharing)', name: 'Bicol Express', description: 'Made with love, made for you.', price: 399.0 },
    { id: 'pd06', category: 'Pinoy Dishes (For Sharing)', name: 'Chicken Wings', description: 'Buffalo, BBQ, or Salted Egg.', price: 430.0 },
    { id: 'pd07', category: 'Pinoy Dishes (For Sharing)', name: 'Whole Fried Chicken', description: 'Made with love, made for you.', price: 789.0 },
    { id: 'pd08', category: 'Pinoy Dishes (For Sharing)', name: 'Crispy Pata', description: 'Made with love, made for you.', price: 950.0 },
    { id: 'pd09', category: 'Pinoy Dishes (For Sharing)', name: 'Papaitan', description: 'Made with love, made for you.', price: 400.0 },
    { id: 'pd10', category: 'Pinoy Dishes (For Sharing)', name: 'Beef Bulalo', description: 'Made with love, made for you.', price: 580.0 },
    { id: 'pd11', category: 'Pinoy Dishes (For Sharing)', name: 'Sinigang (Pork or Shrimp)', description: 'Made with love, made for you.', price: 450.0 },
    { id: 'pd12', category: 'Pinoy Dishes (For Sharing)', name: 'Chopsuey', description: 'Made with love, made for you.', price: 399.0 },
    { id: 'pd13', category: 'Pinoy Dishes (For Sharing)', name: 'Ginisang Ampalaya', description: 'Made with love, made for you.', price: 359.0 },
    { id: 'pd14', category: 'Pinoy Dishes (For Sharing)', name: 'Crispy Pakbet', description: 'Made with love, made for you.', price: 359.0 },
    { id: 'pd15', category: 'Pinoy Dishes (For Sharing)', name: 'Tortang Talong', description: 'Made with love, made for you.', price: 249.0 },
    { id: 'ps01', category: 'Pasta', name: 'Spanish Sardines', description: 'Savory sardines, garlic, olive oil, and a hint of spice.', price: 279.0 },
    { id: 'ps02', category: 'Pasta', name: 'Chicken Alfredo', description: 'Creamy, rich, and indulgent. A classic you\'ll love.', price: 289.0 },
    { id: 'ps03', category: 'Pasta', name: 'Creamy Carbonara', description: 'Rich and creamy sauce with bacon and a touch of parmesan.', price: 289.0 },
    { id: 'ps04', category: 'Pasta', name: 'Meatballs Marinara', description: 'Juicy meatballs in a homemade marinara sauce.', price: 299.0 },
    { id: 'ps05', category: 'Pasta', name: 'Tuna Pesto', description: 'Tender tuna, basil pesto, and a burst of fresh flavor.', price: 299.0 },
    { id: 'ps06', category: 'Pasta', name: 'Shrimp Aglio Olio', description: 'Garlic, olive oil, and juicy shrimp perfectly tossed.', price: 299.0 },
    { id: 'sa01', category: 'Salad', name: 'Crispy Caesar Salad', description: 'Fresh, flavorful.', price: 350.0 },
    { id: 'sa02', category: 'Salad', name: 'Salmon Avocado Salad', description: 'Fresh, flavorful.', price: 420.0 },
    { id: 'sa03', category: 'Salad', name: 'Mango Kani', description: 'Fresh, flavorful.', price: 370.0 },
    { id: 'sl01', category: 'Silog Meals', name: 'Tapa Silog', description: 'Garlic rice, fried egg, fresh sides.', price: 210.0 },
    { id: 'sl02', category: 'Silog Meals', name: 'Spam Silog', description: 'Garlic rice, fried egg, fresh sides.', price: 210.0 },
    { id: 'sl03', category: 'Silog Meals', name: 'Corned Beef Silog', description: 'Garlic rice, fried egg, fresh sides.', price: 210.0 },
    { id: 'sl04', category: 'Silog Meals', name: 'Fried Chicken Silog', description: 'Garlic rice, fried egg, fresh sides.', price: 210.0 },
    { id: 'sl05', category: 'Silog Meals', name: 'Porkchop Silog', description: 'Garlic rice, fried egg, fresh sides.', price: 210.0 },
    { id: 'sl06', category: 'Silog Meals', name: 'Pork Liempo Silog', description: 'Garlic rice, fried egg, fresh sides.', price: 210.0 },
    { id: 'sl07', category: 'Silog Meals', name: 'Hungarian Silog', description: 'Garlic rice, fried egg, fresh sides.', price: 210.0 },
    { id: 'sl08', category: 'Silog Meals', name: 'Bacon Silog', description: 'Garlic rice, fried egg, fresh sides.', price: 210.0 },
    { id: 'sl09', category: 'Silog Meals', name: 'Longganisa Silog', description: 'Garlic rice, fried egg, fresh sides.', price: 210.0 },
    { id: 'sl10', category: 'Silog Meals', name: 'Bangus Silog', description: 'Garlic rice, fried egg, fresh sides.', price: 210.0 },
    { id: 'sl11', category: 'Silog Meals', name: 'Tocino Silog', description: 'Garlic rice, fried egg, fresh sides.', price: 210.0 },
    { id: 'sp01', category: 'Con Vista Specials', name: 'Braised Osso Buco', description: 'Slow-braised veal shank in a rich aromatic sauce, fork-tender with a savory reduction.', price: 979.0 },
    { id: 'sp02', category: 'Con Vista Specials', name: 'Creamy Salmon Supreme', description: 'Seared salmon in a rich, velvety cream sauce.', price: 989.0 },
    { id: 'sp03', category: 'Con Vista Specials', name: 'Chicken Diane', description: 'Pan-seared chicken in a creamy mushroom and mustard sauce.', price: 699.0 },
    { id: 'sp04', category: 'Con Vista Specials', name: 'Spicy Pork Salpicao', description: 'Sautéed pork bites in a garlicky soy glaze with a chili kick.', price: 749.0 },
    { id: 'st01', category: 'Steak', name: 'T-Bone Steak', description: 'Grilled to perfection, served with rice, mashed potato, and vegetables.', price: 309.0 },
    { id: 'st02', category: 'Steak', name: 'Porter House Steak', description: 'Grilled to perfection, served with rice, mashed potato, and vegetables.', price: 349.0 },
    { id: 'st03', category: 'Steak', name: 'Chuck Steak', description: 'Grilled to perfection, served with rice, mashed potato, and vegetables.', price: 599.0 },
    { id: 'su01', category: 'Sushi', name: 'Spam Roll', description: 'Every roll made fresh to order.', price: 249.0 },
    { id: 'su02', category: 'Sushi', name: 'Kani Roll', description: 'Every roll made fresh to order.', price: 249.0 },
    { id: 'su03', category: 'Sushi', name: 'Spicy Tuna', description: 'Every roll made fresh to order.', price: 269.0 },
    { id: 'su04', category: 'Sushi', name: 'Crispy Salmon Roll', description: 'Every roll made fresh to order.', price: 289.0 },
    { id: 'su05', category: 'Sushi', name: 'Spam Musubi', description: 'Every roll made fresh to order.', price: 309.0 },
    { id: 'sw01', category: 'Sandwiches', name: 'Tuna Sandwich', description: 'Fresh, flavorful, made just for you.', price: 200.0 },
    { id: 'sw02', category: 'Sandwiches', name: 'Ham and Cheese', description: 'Fresh, flavorful, made just for you.', price: 200.0 },
    { id: 'sw03', category: 'Sandwiches', name: 'Egg Sandwich', description: 'Fresh, flavorful, made just for you.', price: 200.0 },
    { id: 'sw04', category: 'Sandwiches', name: 'Clubhouse', description: 'Fresh, flavorful, made just for you.', price: 240.0 },
    { id: 'sw05', category: 'Sandwiches', name: 'Katsu Sando', description: 'Fresh, flavorful, made just for you.', price: 260.0 },
    { id: 'tw01', category: 'Towers', name: 'T Sunrise Tower', description: '3 liters. Perfect for groups.', price: 550.0 },
    { id: 'tw02', category: 'Towers', name: 'Galaxy Tower', description: '3 liters. Perfect for groups.', price: 550.0 },
    { id: 'tw03', category: 'Towers', name: 'F Mountain Tower', description: '3 liters. Perfect for groups.', price: 550.0 },
    { id: 'tw04', category: 'Towers', name: 'Red Alert Tower', description: '3 liters. Perfect for groups.', price: 550.0 },
    { id: 'tw05', category: 'Towers', name: 'Velocity Tower', description: '3 liters. Perfect for groups.', price: 550.0 },
    { id: 'tw06', category: 'Towers', name: 'Unicorn Tower', description: '3 liters. Perfect for groups.', price: 550.0 },
    { id: 'tw07', category: 'Towers', name: 'S Driver Tower', description: '3 liters. Perfect for groups.', price: 550.0 },
    { id: 'tw08', category: 'Towers', name: 'C Maxima Tower', description: '3 liters. Perfect for groups.', price: 550.0 },
    { id: 'tw09', category: 'Towers', name: 'Moonlit Tower', description: '3 liters. Perfect for groups.', price: 550.0 },
    { id: 'tw10', category: 'Towers', name: 'Trivista Tower', description: '3 liters. Perfect for groups.', price: 550.0 },
    { id: 'tw11', category: 'Towers', name: 'T Reggae Tower', description: '3 liters. Perfect for groups.', price: 550.0 },
  ];

  /* ======================================================================
     ITEM OPTIONS — flavor/variant choices for specific items, keyed by
     menu item id. To add options to another item later, just add one more
     entry here — no need to touch MENU_ITEMS itself.
     ====================================================================== */
  // Hardcoded fallback so the picker still works instantly on load, even
  // before (or if) the Supabase fetch below completes. Once that fetch
  // succeeds, its results REPLACE this — Supabase becomes the source of
  // truth. To edit flavors going forward, edit the `flavors` column on the
  // relevant row in the menu_items table (a JSON array of strings) — no
  // code changes needed. Leaving this fallback in place also means removing
  // flavors from an item in Supabase (setting it back to null) still works,
  // since that item simply won't appear in the fetch results.
  let ITEM_OPTIONS = {
    'ap01': { label: 'Flavor', choices: ['Original', 'Cheese', 'Sour Cream', 'BBQ'] },       // Fries
    'pd06': { label: 'Flavor', choices: ['Buffalo', 'Spicy', 'Salted Egg'] }                  // Chicken Wings
  };

  /* ======================================================================
     ORDERS — still goes to Supabase via XMLHttpRequest (not fetch, to avoid
     a preview-tool compatibility issue hit earlier). Menu itself needs no
     network at all now.
     ====================================================================== */
  const SUPABASE_URL = 'https://zmcalfrnhmhjjpjlpleh.supabase.co';
  const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InptY2FsZnJuaG1oampwamxwbGVoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc3Mzc1NjQsImV4cCI6MjEwMzMxMzU2NH0.LqxMPTlNnwVuaO5cZ5j-bbQSJmL96Vwlsg1fUrtI7qA';
  const REST_URL = SUPABASE_URL + '/rest/v1';

  function restRequest(path, method, body, extraHeaders) {
    return new Promise(function (resolve) {
      try {
        const xhr = new XMLHttpRequest();
        xhr.open(method || 'GET', REST_URL + path, true);
        xhr.setRequestHeader('apikey', SUPABASE_ANON_KEY);
        xhr.setRequestHeader('Authorization', 'Bearer ' + SUPABASE_ANON_KEY);
        xhr.setRequestHeader('Content-Type', 'application/json');
        if (extraHeaders) {
          Object.keys(extraHeaders).forEach(k => xhr.setRequestHeader(k, extraHeaders[k]));
        }
        xhr.timeout = 15000;
        xhr.onreadystatechange = function () {
          if (xhr.readyState !== 4) return;
          if (xhr.status >= 200 && xhr.status < 300) {
            let data = null;
            try { data = xhr.responseText ? JSON.parse(xhr.responseText) : null; } catch (e) {}
            resolve({ data, error: null });
          } else {
            resolve({ data: null, error: 'HTTP ' + xhr.status + ' ' + xhr.statusText + (xhr.responseText ? ' — ' + xhr.responseText.slice(0, 150) : '') });
          }
        };
        xhr.onerror = function () { resolve({ data: null, error: 'Network error — request could not reach Supabase.' }); };
        xhr.ontimeout = function () { resolve({ data: null, error: 'Request timed out.' }); };
        xhr.send(body ? JSON.stringify(body) : null);
      } catch (e) {
        resolve({ data: null, error: 'Exception — ' + ((e && e.message) || String(e)) });
      }
    });
  }

  /* ======================================================================
     APP LOGIC
     ====================================================================== */
  let cart = {};
  let orderType = null;
  let paymentMethod = null;

  const peso = n => '₱' + Number(n).toLocaleString('en-PH', { minimumFractionDigits: 2 });
  const CATEGORIES = [...new Set(MENU_ITEMS.map(i => i.category))];

  function cssSafe(s) { return s.replace(/[^a-z0-9]/gi, '_'); }
  function escapeHtml(s) {
    return String(s == null ? '' : s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
  }

  function renderCategoryNav() {
    document.getElementById('categoryNav').innerHTML = CATEGORIES.map((c, i) => `
      <button onclick="scrollToCategory('${cssSafe(c)}')"
        class="cat-chip ${i === 0 ? 'active' : ''}" data-cat="${cssSafe(c)}">${escapeHtml(c)}</button>
    `).join('');
  }

  function scrollToCategory(id) {
    document.getElementById('cat-' + id)?.scrollIntoView({ behavior: 'smooth', block: 'start' });
    document.querySelectorAll('.cat-chip').forEach(chip => {
      chip.classList.toggle('active', chip.dataset.cat === id);
    });
  }

  function renderMenu() {
    document.getElementById('menu').innerHTML = CATEGORIES.map(cat => `
      <section id="cat-${cssSafe(cat)}">
        <h2 class="section-title">${escapeHtml(cat)}</h2>
        <div class="item-list">
          ${MENU_ITEMS.filter(i => i.category === cat).map(itemRow).join('')}
        </div>
      </section>
    `).join('');
  }

  function qtyForBaseId(id) {
    // Sums quantity across every cart line belonging to this item — a plain
    // key for items with no options, or "id::flavor" for flavored ones.
    return Object.entries(cart).reduce((sum, [key, entry]) => {
      return key.split('::')[0] === id ? sum + entry.qty : sum;
    }, 0);
  }

  function qtyControlHtml(item) {
    const hasOptions = !!ITEM_OPTIONS[item.id];
    const qty = qtyForBaseId(item.id);

    if (hasOptions) {
      // Multiple flavor variants can exist at once for the same item, so a
      // single +/- pair here would be ambiguous about which one to change.
      // Tapping + always opens the picker; existing quantity is shown as a
      // badge, and can be fine-tuned per-flavor in the checkout review list.
      return `
        <div class="qty-control">
          <button onclick="addToCart('${item.id}')" class="add-btn">+</button>
          ${qty > 0 ? `<span class="qty-badge">${qty} in cart</span>` : ''}
        </div>`;
    }

    if (qty > 0) {
      return `
        <div class="stepper">
          <button onclick="decrementItem('${item.id}')" class="qty-btn">−</button>
          <span class="qty-val">${qty}</span>
          <button onclick="addToCart('${item.id}')" class="qty-btn plus">+</button>
        </div>`;
    }
    return `<button onclick="addToCart('${item.id}')" class="add-btn">+</button>`;
  }

  function refreshItemBox(id) {
    const box = document.getElementById('qtyBox-' + id);
    const item = MENU_ITEMS.find(i => i.id === id);
    if (!box || !item) return;
    box.innerHTML = qtyControlHtml(item);
  }

  function itemRow(item) {
    const soldOut = SOLD_OUT_IDS.has(item.id);
    return `
      <div class="item-card ${soldOut ? 'sold-out' : ''}">
        <div class="item-info">
          <p class="item-name">${escapeHtml(item.name)}</p>
          ${item.description ? `<p class="item-desc">${escapeHtml(item.description)}</p>` : ''}
          <p class="item-price">${peso(item.price)}</p>
        </div>
        ${soldOut
          ? `<span class="sold-out-badge">Sold Out</span>`
          : `<div id="qtyBox-${item.id}">${qtyControlHtml(item)}</div>`}
      </div>`;
  }

  function addCartLine(key, name, price, delta) {
    if (!cart[key]) cart[key] = { name, price, qty: 0 };
    cart[key].qty += delta;
    if (cart[key].qty <= 0) delete cart[key];
  }

  function addToCart(id) {
    if (SOLD_OUT_IDS.has(id)) return; // defensive — UI already hides the button for this case
    const item = MENU_ITEMS.find(i => i.id === id);
    if (!item) return;
    if (ITEM_OPTIONS[id]) {
      openFlavorPicker(id);
      return;
    }
    addCartLine(id, item.name, item.price, 1);
    refreshItemBox(id);
    updateCartBar();
  }

  function decrementItem(id) {
    if (!cart[id]) return;
    cart[id].qty -= 1;
    if (cart[id].qty <= 0) delete cart[id];
    refreshItemBox(id);
    updateCartBar();
  }

  // ---- Flavor / variant picker ----
  let pendingFlavorItemId = null;
  let pendingFlavorChoice = null;

  function openFlavorPicker(id) {
    const item = MENU_ITEMS.find(i => i.id === id);
    const opts = ITEM_OPTIONS[id];
    if (!item || !opts) return;
    pendingFlavorItemId = id;
    pendingFlavorChoice = opts.choices[0];
    document.getElementById('flavorModalTitle').textContent = item.name;
    document.getElementById('flavorModalLabel').textContent = opts.label;
    document.getElementById('flavorChoices').innerHTML = opts.choices.map((c, i) => `
      <button onclick="selectFlavorChoice('${c.replace(/'/g, "\\'")}')"
        class="choice-btn flavor-choice-btn ${i === 0 ? 'selected' : ''}" data-choice="${escapeHtml(c)}">${escapeHtml(c)}</button>
    `).join('');
    document.getElementById('flavorModal').classList.remove('hidden');
  }

  function selectFlavorChoice(choice) {
    pendingFlavorChoice = choice;
    document.querySelectorAll('.flavor-choice-btn').forEach(b => {
      b.classList.toggle('selected', b.dataset.choice === choice);
    });
  }

  function closeFlavorModal() {
    document.getElementById('flavorModal').classList.add('hidden');
    pendingFlavorItemId = null;
    pendingFlavorChoice = null;
  }

  function confirmAddFlavorItem() {
    if (!pendingFlavorItemId || !pendingFlavorChoice) return;
    const item = MENU_ITEMS.find(i => i.id === pendingFlavorItemId);
    const key = pendingFlavorItemId + '::' + pendingFlavorChoice;
    const name = item.name + ' (' + pendingFlavorChoice + ')';
    addCartLine(key, name, item.price, 1);
    refreshItemBox(pendingFlavorItemId);
    updateCartBar();
    closeFlavorModal();
  }

  function cartTotal() { return Object.values(cart).reduce((sum, i) => sum + i.qty * i.price, 0); }
  function cartCount() { return Object.values(cart).reduce((sum, i) => sum + i.qty, 0); }

  // Dine-in orders get a service charge added on top; Take-Out and Pick-Up do not.
  // The rate itself is intentionally never shown in any customer-facing text —
  // only the resulting peso amount is displayed, labeled generically.
  const SERVICE_CHARGE_RATE = 0.05;
  function computeCharges() {
    const subtotal = cartTotal();
    const serviceCharge = orderType === 'dine-in' ? Math.round(subtotal * SERVICE_CHARGE_RATE * 100) / 100 : 0;
    const total = subtotal + serviceCharge;
    return { subtotal, serviceCharge, total };
  }

  function updateCheckoutTotals() {
    const { subtotal, serviceCharge, total } = computeCharges();
    document.getElementById('checkoutSubtotal').textContent = peso(subtotal);
    const scRow = document.getElementById('serviceChargeRow');
    if (serviceCharge > 0) {
      scRow.classList.remove('hidden');
      document.getElementById('checkoutServiceCharge').textContent = peso(serviceCharge);
    } else {
      scRow.classList.add('hidden');
    }
    document.getElementById('checkoutTotal').textContent = peso(total);
  }

  function updateCartBar() {
    const bar = document.getElementById('cartBar');
    if (cartCount() === 0) { bar.classList.add('hidden'); return; }
    bar.classList.remove('hidden');
    document.getElementById('cartInfo').textContent = `${cartCount()} items · ${peso(cartTotal())}`;
  }

  function renderCheckoutItemsSummary() {
    const entries = Object.entries(cart);
    const box = document.getElementById('checkoutItemsSummary');
    if (!entries.length) {
      box.innerHTML = '<p class="empty-cart-note">Your cart is empty.</p>';
      return;
    }
    box.innerHTML = entries.map(([key, i]) => `
      <div class="checkout-item-row">
        <span>${i.qty}× ${escapeHtml(i.name)}</span>
        <span class="checkout-item-right">
          <span>${peso(i.qty * i.price)}</span>
          <button type="button" onclick="removeCartLine('${key.replace(/'/g, "\\'")}')" class="remove-line-btn" aria-label="Remove one">−</button>
        </span>
      </div>
    `).join('');
  }

  function removeCartLine(key) {
    if (!cart[key]) return;
    const baseId = key.split('::')[0];
    cart[key].qty -= 1;
    if (cart[key].qty <= 0) delete cart[key];
    renderCheckoutItemsSummary();
    updateCheckoutTotals();
    updateCartBar();
    refreshItemBox(baseId);
    if (cartCount() === 0) closeCheckout();
  }

  function openCheckout() {
    // Defensive: force the selection form to be what's shown every single
    // time checkout opens, regardless of what was displayed last time.
    // The receipt must never be visible until placeOrder() actually succeeds.
    document.getElementById('sheetTitle').textContent = 'Checkout';
    document.getElementById('checkoutForm').classList.remove('hidden');
    document.getElementById('receiptView').classList.add('hidden');
    document.getElementById('checkoutError').classList.remove('visible');
    renderCheckoutItemsSummary();
    updateCheckoutTotals();
    document.getElementById('checkoutModal').classList.remove('hidden');
  }
  function closeCheckout() {
    document.getElementById('checkoutModal').classList.add('hidden');
    // Restore the form view underneath so the next checkout starts fresh
    document.getElementById('sheetTitle').textContent = 'Checkout';
    document.getElementById('checkoutForm').classList.remove('hidden');
    document.getElementById('receiptView').classList.add('hidden');
    document.getElementById('checkoutError').classList.remove('visible');
  }
  function handleCloseTap() {
    // If the receipt is showing and hasn't been saved yet, closing via the
    // header ✕ must go through the same confirmation as the manual-override
    // link — it cannot be used to silently skip the save requirement.
    const receiptVisible = !document.getElementById('receiptView').classList.contains('hidden');
    const stillGated = document.getElementById('receiptDoneBtn').disabled;
    if (receiptVisible && stillGated) {
      if (confirm('Are you sure you already saved a screenshot of your receipt? You\'ll need it as your order reference.')) {
        markSaved();
        closeCheckout();
      }
      return;
    }
    closeCheckout();
  }

  function selectOrderType(btn) {
    document.querySelectorAll('.order-type-btn').forEach(b => b.classList.remove('selected'));
    btn.classList.add('selected');
    orderType = btn.dataset.value;
    updateCheckoutTotals();
  }
  function selectPayment(btn) {
    document.querySelectorAll('.payment-btn').forEach(b => b.classList.remove('selected'));
    btn.classList.add('selected');
    paymentMethod = btn.dataset.value;
  }

  function orderTypeLabel(v) { return { 'dine-in': 'Dine-In', 'takeout': 'Take-Out', 'pickup': 'Pick-Up' }[v] || v; }

  // ---- Order number + date/time, generated locally at the moment of order placement ----
  function formatOrderNumber(n) {
    return 'CV-' + String(n).padStart(6, '0');
  }
  function formatReceiptDateTime() {
    return new Intl.DateTimeFormat('en-PH', {
      timeZone: 'Asia/Manila', weekday: 'short', month: 'short', day: 'numeric', year: 'numeric',
      hour: 'numeric', minute: '2-digit', hour12: true
    }).format(new Date());
  }

  let CURRENT_RECEIPT = null; // holds the data needed to redraw the receipt as an image

  function showReceipt(d) {
    CURRENT_RECEIPT = d;

    document.getElementById('sheetTitle').textContent = 'Order Confirmed';
    document.getElementById('checkoutForm').classList.add('hidden');
    document.getElementById('receiptView').classList.remove('hidden');

    document.getElementById('rcptOrderNo').textContent = formatOrderNumber(d.orderNumber);
    document.getElementById('rcptDateTime').textContent = formatReceiptDateTime();
    document.getElementById('rcptOrderType').textContent = orderTypeLabel(d.orderType);

    document.getElementById('rcptItems').innerHTML = d.items.map(i => `
      <div class="receipt-row"><span>${i.qty}× ${escapeHtml(i.name)}</span><span>${peso(i.qty * i.price)}</span></div>
    `).join('');

    document.getElementById('rcptSubtotal').textContent = peso(d.subtotal);
    const scRow = document.getElementById('rcptServiceChargeRow');
    if (d.serviceCharge > 0) {
      scRow.classList.remove('hidden');
      document.getElementById('rcptServiceCharge').textContent = peso(d.serviceCharge);
    } else {
      scRow.classList.add('hidden');
    }
    document.getElementById('rcptTotal').textContent = peso(d.total);

    const paymentNoteText = d.isPaid
      ? "Your payment has been received. We're preparing your order now."
      : 'Please proceed to pay directly at the cashier.';
    document.getElementById('rcptPaymentNote').textContent = paymentNoteText;
    CURRENT_RECEIPT.paymentNoteText = paymentNoteText;

    // Reset the save-gate: every new receipt must be saved (or explicitly
    // skipped) again before "Done" becomes available.
    document.getElementById('receiptDoneBtn').disabled = true;
    document.getElementById('saveReceiptBtn').disabled = false;
    document.getElementById('saveReceiptBtn').textContent = '📥 Save Receipt to Photos';
    const statusEl = document.getElementById('saveReceiptStatus');
    statusEl.classList.add('hidden');
    statusEl.textContent = '';
  }

  // ---- Draw the receipt as a plain <canvas> image — no external libraries ----
  function wrapLines(ctx, text, maxWidth) {
    const words = String(text).split(' ');
    const lines = [];
    let line = '';
    words.forEach(word => {
      const test = line ? line + ' ' + word : word;
      if (ctx.measureText(test).width > maxWidth && line) {
        lines.push(line);
        line = word;
      } else {
        line = test;
      }
    });
    if (line) lines.push(line);
    return lines;
  }

  function buildReceiptCanvas(d) {
    const W = 380;
    const PAD = 24;
    const contentW = W - PAD * 2;
    const lineH = 20;

    // First pass: measure with a throwaway context to know total height
    const measureCanvas = document.createElement('canvas');
    const mctx = measureCanvas.getContext('2d');
    mctx.font = '12px monospace';
    const paymentLines = wrapLines(mctx, d.paymentNoteText, contentW);
    const gamesText = 'Sit back and relax! Feel free to borrow any of our tabletop games while you wait for your food or drinks to be served.';
    const gamesLines = wrapLines(mctx, gamesText, contentW);

    let H = 0;
    H += 40;                         // title
    H += 20;                         // subtitle
    H += 14;                         // gap
    H += lineH * 4;                  // order no / date / location / type
    H += 14;                         // divider gap
    H += lineH * d.items.length;     // items
    H += 14;                         // divider gap
    H += lineH * (d.serviceCharge > 0 ? 3 : 2); // subtotal / service charge / total
    H += 18;                         // gap
    H += lineH * paymentLines.length;
    H += 6;
    H += lineH * gamesLines.length;
    H += 24;                         // footer thank you
    H += PAD * 2;

    const canvas = document.createElement('canvas');
    canvas.width = W;
    canvas.height = H;
    const ctx = canvas.getContext('2d');

    ctx.fillStyle = '#ffffff';
    ctx.fillRect(0, 0, W, H);
    ctx.fillStyle = '#1c1917';
    ctx.textBaseline = 'top';

    let y = PAD;
    ctx.font = 'bold 18px sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText('CON VISTA CAFE AND DINING', W / 2, y);
    y += 26;
    ctx.font = '12px sans-serif';
    ctx.fillStyle = '#78716c';
    ctx.fillText('Con Vista Antipolo', W / 2, y);
    y += 24;

    ctx.textAlign = 'left';
    ctx.fillStyle = '#1c1917';
    ctx.font = '13px monospace';

    function row(label, value, opts) {
      opts = opts || {};
      ctx.font = (opts.bold ? 'bold ' : '') + (opts.size || 13) + 'px monospace';
      ctx.fillStyle = opts.color || '#1c1917';
      ctx.textAlign = 'left';
      ctx.fillText(label, PAD, y);
      ctx.textAlign = 'right';
      ctx.fillText(value, W - PAD, y);
      y += lineH;
    }
    function divider() {
      ctx.strokeStyle = '#d6d3d1';
      ctx.beginPath();
      ctx.setLineDash([3, 3]);
      ctx.moveTo(PAD, y + 6);
      ctx.lineTo(W - PAD, y + 6);
      ctx.stroke();
      ctx.setLineDash([]);
      y += 16;
    }

    row('Order No.', formatOrderNumber(d.orderNumber), { bold: true, color: '#c2410c' });
    row('Date & Time', formatReceiptDateTime());
    row('Location', 'Con Vista Antipolo');
    row('Order Type', orderTypeLabel(d.orderType));
    divider();

    d.items.forEach(i => {
      row(`${i.qty}× ${i.name}`, peso(i.qty * i.price));
    });
    divider();

    row('Subtotal', peso(d.subtotal));
    if (d.serviceCharge > 0) row('Service Charge', peso(d.serviceCharge));
    row('TOTAL', peso(d.total), { bold: true, size: 15 });

    y += 6;
    ctx.font = '12px sans-serif';
    ctx.fillStyle = '#57534e';
    ctx.textAlign = 'left';
    paymentLines.forEach(line => { ctx.fillText(line, PAD, y); y += lineH; });
    y += 4;
    gamesLines.forEach(line => { ctx.fillText(line, PAD, y); y += lineH; });

    y += 10;
    ctx.font = 'italic 12px sans-serif';
    ctx.textAlign = 'center';
    ctx.fillStyle = '#a8a29e';
    ctx.fillText('Thank you for dining with us!', W / 2, y);

    return canvas;
  }

  async function saveReceiptImage() {
    if (!CURRENT_RECEIPT) return;
    const btn = document.getElementById('saveReceiptBtn');
    const statusEl = document.getElementById('saveReceiptStatus');
    btn.disabled = true;
    btn.textContent = 'Preparing image…';

    try {
      const canvas = buildReceiptCanvas(CURRENT_RECEIPT);
      const blob = await new Promise(resolve => canvas.toBlob(resolve, 'image/png'));
      if (!blob) throw new Error('Could not generate image.');

      const filename = 'ConVista_Receipt_' + formatOrderNumber(CURRENT_RECEIPT.orderNumber) + '.png';
      const file = new File([blob], filename, { type: 'image/png' });

      // Prefer the native share sheet — on iPhone and Android this gives the
      // customer a direct "Save Image" / "Save to Photos" option.
      if (navigator.canShare && navigator.canShare({ files: [file] })) {
        await navigator.share({ files: [file], title: 'Con Vista Receipt', text: filename });
        statusEl.textContent = 'Share menu opened — choose "Save Image" to add it to your Photos.';
      } else {
        // Fallback: trigger a direct file download.
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        setTimeout(() => URL.revokeObjectURL(url), 5000);
        statusEl.textContent = 'Receipt downloaded. If it didn\'t save automatically, check your Downloads or long-press the image to save it to Photos.';
      }
      statusEl.classList.remove('hidden');
    } catch (e) {
      // Covers the user cancelling the native share sheet, or any other
      // failure — never leave them stuck with no way forward.
      statusEl.textContent = 'Could not save automatically. Please take a screenshot of this receipt instead.';
      statusEl.classList.remove('hidden');
    } finally {
      markSaved();
      btn.disabled = false;
      btn.textContent = '📥 Save Receipt Again';
    }
  }

  function markSaved() {
    document.getElementById('receiptDoneBtn').disabled = false;
  }

  function confirmSkipSave() {
    if (confirm('Are you sure you already saved a screenshot of your receipt? You\'ll need it as your order reference.')) {
      markSaved();
    }
  }



  async function placeOrder() {
    const errEl = document.getElementById('checkoutError');
    errEl.classList.remove('visible');

    if (!orderType || !paymentMethod) {
      errEl.textContent = 'Please choose an order type and payment method.';
      errEl.classList.add('visible');
      return;
    }

    const btn = document.getElementById('placeOrderBtn');
    btn.disabled = true;
    btn.textContent = 'Placing order…';

    const items = Object.values(cart).map(i => ({ name: i.name, price: i.price, qty: i.qty }));
    const { subtotal, serviceCharge, total } = computeCharges();
    const isPaid = paymentMethod !== 'Cash';

    const payload = {
      order_type: orderType,
      items: items,
      subtotal: subtotal,
      service_charge_percent: orderType === 'dine-in' ? SERVICE_CHARGE_RATE * 100 : 0,
      service_charge: serviceCharge,
      total: total,
      payment_method: paymentMethod,
      paid: isPaid,
      status: 'new'
    };

    const { data, error } = await restRequest('/orders', 'POST', payload, { Prefer: 'return=representation' });

    if (error) {
      errEl.textContent = 'Failed to place order: ' + error;
      errEl.classList.add('visible');
      btn.disabled = false;
      btn.textContent = 'Place Order';
      return;
    }

    const insertedOrder = Array.isArray(data) ? data[0] : data;
    if (!insertedOrder || insertedOrder.order_number == null) {
      // The insert itself succeeded, but we didn't get the row back with its
      // assigned number — surface this rather than showing a blank/guessed one.
      errEl.textContent = 'Order was placed, but we could not retrieve your order number. Please show this screen to staff.';
      errEl.classList.add('visible');
      btn.disabled = false;
      btn.textContent = 'Place Order';
      return;
    }

    const capturedItems = items;
    const capturedOrderType = orderType;
    const capturedIsPaid = isPaid;
    const capturedOrderNumber = insertedOrder.order_number;

    cart = {}; orderType = null; paymentMethod = null;
    updateCartBar();
    document.querySelectorAll('.order-type-btn, .payment-btn').forEach(b => b.classList.remove('selected'));

    showReceipt({
      items: capturedItems,
      subtotal: subtotal,
      serviceCharge: serviceCharge,
      total: total,
      orderType: capturedOrderType,
      isPaid: capturedIsPaid,
      orderNumber: capturedOrderNumber
    });

    btn.disabled = false;
    btn.textContent = 'Place Order';
  }

  // Menu renders instantly — no loading state, no network call, no way to fail.
  // Refresh flavor options AND live sold-out status from Supabase in the
  // background. Runs after the menu is already rendered and interactive, so
  // it never blocks or delays anything the customer sees. To mark an item
  // sold out, just flip its `available` column to false in the menu_items
  // table — no code changes needed, same as editing flavors.
  let SOLD_OUT_IDS = new Set();

  async function syncLiveMenuDataFromSupabase() {
    const { data, error } = await restRequest('/menu_items?select=id,flavors,available', 'GET');
    if (error || !Array.isArray(data)) return; // keep local fallback as-is
    const freshOptions = {};
    const freshSoldOut = new Set();
    data.forEach(row => {
      if (Array.isArray(row.flavors) && row.flavors.length > 0) {
        freshOptions[row.id] = { label: 'Flavor', choices: row.flavors };
      }
      if (row.available === false) {
        freshSoldOut.add(row.id);
      }
    });
    ITEM_OPTIONS = freshOptions;
    SOLD_OUT_IDS = freshSoldOut;
    renderMenu(); // re-render so any newly sold-out items show correctly
  }

  renderCategoryNav();
  renderMenu();
  syncLiveMenuDataFromSupabase();
</script>
</body>
</html>
