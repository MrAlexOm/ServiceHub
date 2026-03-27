// Configuration
const WHITELIST_EMAILS = [
    'aleksandrmaslov910@gmail.com',
    'director@servicehub.com',
    'manager@servicehub.com'
];

// State management
let authAttempts = 0;
let currentUser = null;

// Screen management
function showScreen(screenId) {
    document.querySelectorAll('.screen').forEach(screen => {
        screen.classList.remove('active');
    });
    document.getElementById(screenId).classList.add('active');
}

// Navigation functions
function navigateToMaster() {
    showScreen('masterHomeScreen');
}

function navigateToAdmin() {
    showScreen('adminAuthScreen');
    loadSavedCredentials();
}

function backToRoleSelection() {
    showScreen('roleSelectionScreen');
    resetAuthForm();
}

// Authentication functions
function loadSavedCredentials() {
    const savedEmail = localStorage.getItem('admin_email');
    const savedPassword = localStorage.getItem('admin_password');
    
    if (savedEmail && savedPassword) {
        document.getElementById('email').value = savedEmail;
        document.getElementById('password').value = savedPassword;
    }
}

function saveCredentials(email, password) {
    localStorage.setItem('admin_email', email);
    localStorage.setItem('admin_password', password);
}

async function handleAdminAuth(event) {
    event.preventDefault();
    
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value;
    const loginBtn = document.getElementById('loginBtn');
    const btnText = loginBtn.querySelector('.btn-text');
    const spinner = loginBtn.querySelector('.spinner');
    const errorMessage = document.getElementById('errorMessage');
    
    // Show loading state
    loginBtn.disabled = true;
    btnText.textContent = 'Вход...';
    spinner.style.display = 'block';
    errorMessage.style.display = 'none';
    
    // Simulate network delay
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    if (WHITELIST_EMAILS.includes(email)) {
        // Success
        saveCredentials(email, password);
        currentUser = email;
        
        // Reset button state
        loginBtn.disabled = false;
        btnText.textContent = 'Вход';
        spinner.style.display = 'none';
        
        // Show success message and navigate
        showSuccessMessage();
        setTimeout(() => {
            window.location.href = 'admin_panel.html';
        }, 1500);
        
    } else {
        // Failed
        authAttempts++;
        
        // Reset button state
        loginBtn.disabled = false;
        btnText.textContent = 'Вход';
        spinner.style.display = 'none';
        
        // Show error after 2 attempts
        if (authAttempts >= 2) {
            errorMessage.style.display = 'block';
        }
        
        // Clear password field
        document.getElementById('password').value = '';
    }
}

function showSuccessMessage() {
    const successDiv = document.createElement('div');
    successDiv.className = 'success-message';
    successDiv.innerHTML = `
        <i class="fas fa-check-circle"></i>
        <span>Авторизация прошла успешно!</span>
    `;
    successDiv.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background-color: #28A745;
        color: white;
        padding: 16px 20px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        gap: 10px;
        box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        z-index: 1000;
        animation: slideIn 0.3s ease;
    `;
    
    document.body.appendChild(successDiv);
    
    setTimeout(() => {
        successDiv.remove();
    }, 3000);
}

function resetAuthForm() {
    document.getElementById('adminAuthForm').reset();
    document.getElementById('errorMessage').style.display = 'none';
    authAttempts = 0;
}

function logout() {
    currentUser = null;
    // Optional: Clear saved credentials
    // localStorage.removeItem('admin_email');
    // localStorage.removeItem('admin_password');
    
    showScreen('roleSelectionScreen');
    resetAuthForm();
}

// Add slide-in animation
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    .success-message i {
        font-size: 20px;
    }
`;
document.head.appendChild(style);

// Initialize app
document.addEventListener('DOMContentLoaded', function() {
    showScreen('roleSelectionScreen');
});

// Handle browser back button
window.addEventListener('popstate', function(event) {
    if (document.getElementById('adminDashboardScreen').classList.contains('active')) {
        event.preventDefault();
        logout();
    } else if (document.getElementById('adminAuthScreen').classList.contains('active') || 
               document.getElementById('masterHomeScreen').classList.contains('active')) {
        event.preventDefault();
        backToRoleSelection();
    }
});
