document.addEventListener('DOMContentLoaded', function () {
    fetch('data.json')
      .then(response => response.json())
      .then(data => {
        const currencyData = data.data;
        const lastUpdatedAt = data.meta.last_updated_at;
      
      // Update the HTML element with the last update information
        const lastUpdateElement = document.getElementById('lastUpdate');
        lastUpdateElement.textContent = 'Last data update at: ' + lastUpdatedAt;
  
        // Get the table body element
        const tableBody = document.getElementById('currencyTableBody');
  
        // Counter for row index
        let rowIndex = 1;
  
        // Iterate over the currency data and generate table rows
        for (const currencyCode in currencyData) {
          if (currencyData.hasOwnProperty(currencyCode)) {
            const currency = currencyData[currencyCode];
  
            // Create a new table row
            const row = document.createElement('tr');
  
            // Create table cell for the index
            const indexCell = document.createElement('td');
            indexCell.textContent = rowIndex;
            row.appendChild(indexCell);
  
            // Create table cells for code and value
            const codeCell = document.createElement('td');
            codeCell.textContent = currency.code;
            row.appendChild(codeCell);
  
            const valueCell = document.createElement('td');
            valueCell.textContent = currency.value;
            row.appendChild(valueCell);
  
            // Append the row to the table body
            tableBody.appendChild(row);
  
            // Increment the row index
            rowIndex++;
          }
        }
      })
      .catch(error => {
        console.error('Error:', error);
      });
  });

