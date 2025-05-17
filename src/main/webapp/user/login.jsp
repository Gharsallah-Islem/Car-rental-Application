<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wheels - Login</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- GSAP for animations -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <!-- Three.js for WebGL -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r134/three.min.js"></script>
    <style>
        body {
            margin: 0;
            overflow: hidden;
            background: linear-gradient(135deg, #f5f5f5, #e5e5e5);
        }
        #webgl-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
        }
        .car-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('https://images.unsplash.com/photo-1502877338535-766e1452684a?q=80&w=2072&auto=format&fit=crop') no-repeat center center/cover;
            opacity: 0.15;
            z-index: -1;
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        .btn-gradient {
            background: linear-gradient(to right, #ef4444, #dc2626);
            transition: all 0.3s ease;
        }
        .btn-gradient:hover {
            background: linear-gradient(to right, #dc2626, #ef4444);
            transform: scale(1.05);
        }
        .input-focus {
            transition: all 0.3s ease;
        }
        .input-focus:focus {
            border-color: #ef4444;
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.2);
        }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen relative">
<!-- WebGL Background -->
<div id="webgl-bg"></div>
<!-- Car Image Overlay -->
<div class="car-overlay"></div>
<!-- Glassmorphism Card -->
<div class="glass-card p-8 rounded-2xl w-full max-w-md z-10">
    <h1 class="text-4xl font-extrabold text-gray-800 text-center mb-6 animate-pulse">Login to Wheels</h1>
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <p class="text-red-500 text-center mb-4"><%= error %></p>
    <%
        }
    %>
    <form action="${pageContext.request.contextPath}/auth" method="post" class="space-y-5">
        <input type="hidden" name="action" value="login">
        <div>
            <label for="username" class="block text-sm font-medium text-gray-700">Username or Email</label>
            <input type="text" id="username" name="username" required
                   class="input-focus mt-1 w-full px-4 py-3 border border-gray-300 rounded-lg bg-white/80 focus:outline-none">
        </div>
        <div>
            <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
            <input type="password" id="password" name="password" required
                   class="input-focus mt-1 w-full px-4 py-3 border border-gray-300 rounded-lg bg-white/80 focus:outline-none">
        </div>
        <div>
            <button type="submit"
                    class="btn-gradient w-full text-white py-3 rounded-lg font-semibold shadow-lg">
                Login
            </button>
        </div>
    </form>
    <p class="mt-5 text-center text-sm text-gray-600">
        Don't have an account? <a href="${pageContext.request.contextPath}/user/signup.jsp" class="text-red-500 hover:underline font-medium">Sign Up</a>
    </p>
</div>

<!-- WebGL Particle Background Script -->
<script>
    // WebGL Background with Three.js
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true });
    renderer.setSize(window.innerWidth, window.innerHeight);
    document.getElementById('webgl-bg').appendChild(renderer.domElement);

    // Create particle system
    const particleCount = 500;
    const particles = new THREE.BufferGeometry();
    const positions = new Float32Array(particleCount * 3);
    const colors = new Float32Array(particleCount * 3);

    for (let i = 0; i < particleCount * 3; i += 3) {
        positions[i] = (Math.random() - 0.5) * 100;
        positions[i + 1] = (Math.random() - 0.5) * 100;
        positions[i + 2] = (Math.random() - 0.5) * 100;
        colors[i] = 1; // Red
        colors[i + 1] = 0.3; // Slight orange tint
        colors[i + 2] = 0.3;
    }

    particles.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    particles.setAttribute('color', new THREE.BufferAttribute(colors, 3));

    const particleMaterial = new THREE.PointsMaterial({
        size: 0.5,
        vertexColors: true,
        transparent: true,
        opacity: 0.6
    });

    const particleSystem = new THREE.Points(particles, particleMaterial);
    scene.add(particleSystem);

    camera.position.z = 50;

    function animate() {
        requestAnimationFrame(animate);
        particleSystem.rotation.y += 0.001;
        particleSystem.rotation.x += 0.0005;
        renderer.render(scene, camera);
    }
    animate();

    // Handle window resize
    window.addEventListener('resize', () => {
        renderer.setSize(window.innerWidth, window.innerHeight);
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
    });

    // GSAP Animations for the card
    gsap.from('.glass-card', { opacity: 0, y: 50, duration: 1, ease: 'power3.out' });
    gsap.from('h1', { opacity: 0, scale: 0.8, duration: 1, delay: 0.3, ease: 'elastic.out(1, 0.5)' });
</script>
</body>
</html>