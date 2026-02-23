<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>CBB Welfare</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<nav class="navbar navbar-expand-lg bg-white border-bottom">
  <div class="container">
    <a class="navbar-brand fw-bold" href="{{ url('/') }}">CBB Welfare</a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="nav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="{{ url('/') }}">Home</a></li>
        <li class="nav-item"><a class="nav-link" href="{{ url('/about') }}">About Us</a></li>
        <li class="nav-item"><a class="nav-link" href="{{ url('/committee') }}">Executive Committee</a></li>
        <li class="nav-item"><a class="nav-link" href="{{ url('/members') }}">Members</a></li>
        <li class="nav-item"><a class="nav-link" href="{{ url('/gallery') }}">Gallery</a></li>
        <li class="nav-item"><a class="nav-link" href="{{ url('/notice') }}">Notice</a></li>
        <li class="nav-item"><a class="nav-link" href="{{ url('/publications') }}">Publications</a></li>
        <li class="nav-item"><a class="nav-link" href="{{ url('/contact') }}">Contact Us</a></li>
      </ul>
    </div>
  </div>
</nav>

<main class="container py-5">
  @yield('content')
</main>

<footer class="bg-dark text-white text-center py-3 mt-5">
  © {{ date('Y') }} CBB Welfare Association
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
