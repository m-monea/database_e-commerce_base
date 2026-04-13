const db = {
  users: [
    { id: 1, full_name: 'Mario Rossi', email: 'mario.rossi@email.com', city: 'Milano', created_at: '2026-01-10' },
    { id: 2, full_name: 'Laura Bianchi', email: 'laura.bianchi@email.com', city: 'Roma', created_at: '2026-01-15' },
    { id: 3, full_name: 'Giulia Verdi', email: 'giulia.verdi@email.com', city: 'Torino', created_at: '2026-02-03' },
    { id: 4, full_name: 'Luca Neri', email: 'luca.neri@email.com', city: 'Napoli', created_at: '2026-02-18' }
  ],
  products: [
    { id: 1, name: 'Mouse Wireless', category: 'Accessori', price: 24.90, stock: 42 },
    { id: 2, name: 'Tastiera Meccanica', category: 'Accessori', price: 79.90, stock: 15 },
    { id: 3, name: 'Monitor 27 pollici', category: 'Monitor', price: 219.00, stock: 9 },
    { id: 4, name: 'Notebook Pro 14', category: 'Computer', price: 999.00, stock: 5 }
  ],
  orders: [
    { id: 101, user_id: 1, order_date: '2026-03-01', status: 'completed', total_amount: 104.80 },
    { id: 102, user_id: 2, order_date: '2026-03-03', status: 'processing', total_amount: 219.00 },
    { id: 103, user_id: 1, order_date: '2026-03-05', status: 'completed', total_amount: 999.00 },
    { id: 104, user_id: 3, order_date: '2026-03-07', status: 'cancelled', total_amount: 79.90 }
  ],
  order_items: [
    { order_id: 101, product_id: 1, quantity: 1, unit_price: 24.90 },
    { order_id: 101, product_id: 2, quantity: 1, unit_price: 79.90 },
    { order_id: 102, product_id: 3, quantity: 1, unit_price: 219.00 },
    { order_id: 103, product_id: 4, quantity: 1, unit_price: 999.00 },
    { order_id: 104, product_id: 2, quantity: 1, unit_price: 79.90 }
  ]
};

const views = document.querySelectorAll('.view');
const buttons = document.querySelectorAll('.nav-btn');

buttons.forEach(button => {
  button.addEventListener('click', () => {
    buttons.forEach(btn => btn.classList.remove('active'));
    views.forEach(view => view.classList.remove('active'));
    button.classList.add('active');
    document.getElementById(button.dataset.view).classList.add('active');
  });
});

function euro(value) {
  return new Intl.NumberFormat('it-IT', { style: 'currency', currency: 'EUR' }).format(value);
}

function badgeClass(status) {
  if (status === 'completed') return 'ok';
  if (status === 'processing') return 'warn';
  if (status === 'cancelled') return 'danger';
  return 'info';
}

function getUserById(id) {
  return db.users.find(user => user.id === id);
}

function getProductById(id) {
  return db.products.find(product => product.id === id);
}

function renderDashboard() {
  const totalRevenue = db.orders
    .filter(order => order.status === 'completed')
    .reduce((sum, order) => sum + order.total_amount, 0);

  const totalProductsSold = db.order_items.reduce((sum, item) => sum + item.quantity, 0);

  const recentOrders = [...db.orders]
    .sort((a, b) => new Date(b.order_date) - new Date(a.order_date))
    .slice(0, 3);

  document.getElementById('dashboard').innerHTML = `
    <div class="grid">
      <div class="card">
        <p class="muted">Utenti registrati</p>
        <div class="metric">${db.users.length}</div>
        <p class="muted">Persone salvate nella tabella users</p>
      </div>
      <div class="card">
        <p class="muted">Prodotti attivi</p>
        <div class="metric">${db.products.length}</div>
        <p class="muted">Elementi presenti nella tabella products</p>
      </div>
      <div class="card">
        <p class="muted">Ordini creati</p>
        <div class="metric">${db.orders.length}</div>
        <p class="muted">Record presenti nella tabella orders</p>
      </div>
      <div class="card">
        <p class="muted">Incasso ordini completati</p>
        <div class="metric">${euro(totalRevenue)}</div>
        <p class="muted">Somma dei total_amount con stato completed</p>
      </div>
    </div>

    <div class="table-card">
      <div class="table-title">
        <h2>Come si leggono i dati</h2>
        <span class="badge info">Vista introduttiva</span>
      </div>
      <p class="muted">
        La dashboard mette insieme informazioni da più tabelle. È il corrispettivo visivo di una query con JOIN.
      </p>
    </div>

    <div class="table-card">
      <div class="table-title">
        <h2>Ultimi ordini</h2>
      </div>
      <table>
        <thead>
          <tr>
            <th>ID ordine</th>
            <th>Cliente</th>
            <th>Data</th>
            <th>Stato</th>
            <th>Totale</th>
          </tr>
        </thead>
        <tbody>
          ${recentOrders.map(order => `
            <tr>
              <td>#${order.id}</td>
              <td>${getUserById(order.user_id).full_name}</td>
              <td>${order.order_date}</td>
              <td><span class="badge ${badgeClass(order.status)}">${order.status}</span></td>
              <td>${euro(order.total_amount)}</td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    </div>
  `;
}

function renderUsers() {
  document.getElementById('users').innerHTML = `
    <div class="table-card">
      <div class="table-title">
        <h2>Tabella users</h2>
        <span class="badge info">Chi compra</span>
      </div>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Nome</th>
            <th>Email</th>
            <th>Città</th>
            <th>Registrazione</th>
          </tr>
        </thead>
        <tbody>
          ${db.users.map(user => `
            <tr>
              <td>${user.id}</td>
              <td>${user.full_name}</td>
              <td>${user.email}</td>
              <td>${user.city}</td>
              <td>${user.created_at}</td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    </div>
  `;
}

function renderProducts() {
  document.getElementById('products').innerHTML = `
    <div class="table-card">
      <div class="table-title">
        <h2>Tabella products</h2>
        <span class="badge info">Cosa vendiamo</span>
      </div>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Prodotto</th>
            <th>Categoria</th>
            <th>Prezzo</th>
            <th>Stock</th>
          </tr>
        </thead>
        <tbody>
          ${db.products.map(product => `
            <tr>
              <td>${product.id}</td>
              <td>${product.name}</td>
              <td>${product.category}</td>
              <td>${euro(product.price)}</td>
              <td>${product.stock}</td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    </div>
  `;
}

function renderOrders() {
  const rows = db.orders.map(order => {
    const user = getUserById(order.user_id);
    const items = db.order_items
      .filter(item => item.order_id === order.id)
      .map(item => {
        const product = getProductById(item.product_id);
        return `${product.name} x${item.quantity}`;
      })
      .join(', ');

    return `
      <tr>
        <td>#${order.id}</td>
        <td>${user.full_name}</td>
        <td>${order.order_date}</td>
        <td>${items}</td>
        <td><span class="badge ${badgeClass(order.status)}">${order.status}</span></td>
        <td>${euro(order.total_amount)}</td>
      </tr>
    `;
  }).join('');

  document.getElementById('orders').innerHTML = `
    <div class="table-card">
      <div class="table-title">
        <h2>Vista ordini con JOIN logica</h2>
        <span class="badge info">orders + users + order_items + products</span>
      </div>
      <table>
        <thead>
          <tr>
            <th>Ordine</th>
            <th>Cliente</th>
            <th>Data</th>
            <th>Prodotti</th>
            <th>Stato</th>
            <th>Totale</th>
          </tr>
        </thead>
        <tbody>${rows}</tbody>
      </table>
    </div>
  `;
}

function renderJoins() {
  document.getElementById('joins').innerHTML = `
    <div class="join-card">
      <h2>JOIN 1: vedere ogni ordine con il nome del cliente</h2>
      <p class="muted">Qui colleghiamo orders a users usando user_id.</p>
      <div class="code">SELECT o.id, o.order_date, o.status, u.full_name
FROM orders o
JOIN users u ON o.user_id = u.id
ORDER BY o.order_date DESC;</div>
    </div>

    <div class="join-card">
      <h2>JOIN 2: vedere i prodotti presenti in ogni ordine</h2>
      <p class="muted">Qui usiamo la tabella ponte order_items.</p>
      <div class="code">SELECT o.id AS order_id, u.full_name, p.name, oi.quantity, oi.unit_price
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
ORDER BY o.id, p.name;</div>
    </div>

    <div class="join-card">
      <h2>Perché la tabella order_items è importante</h2>
      <p class="muted">
        Un ordine può contenere tanti prodotti e un prodotto può comparire in tanti ordini.
        Questa è una relazione molti-a-molti. La tabella order_items serve proprio a gestirla bene.
      </p>
    </div>

    <div class="join-card">
      <h2>Indice utile</h2>
      <div class="code">CREATE INDEX idx_orders_user_status_date
ON orders (user_id, status, order_date DESC);</div>
      <p class="muted">
        Questo indice aiuta quando cerchiamo rapidamente gli ordini di un certo utente,
        con uno stato preciso e ordinati per data.
      </p>
    </div>
  `;
}

renderDashboard();
renderUsers();
renderProducts();
renderOrders();
renderJoins();
