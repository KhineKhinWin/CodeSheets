<%@ page import="java.util.*, com.cheatsheet.model.Favorite" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Saved Favorites</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
</head>
<body class="bg-light">

<div class="container my-5">
    <h2 class="mb-4"><i class="fa-solid fa-bookmark text-warning"></i> My Favorite Cheatsheets</h2>
    
    <div class="row">
        <%
        // Servlet က ပို့လိုက်တဲ့ List<Favorite> ကို စနစ်တကျ Type Cast လုပ်ပြီး ယူပါတယ်
        List<Favorite> myFavorites = (List<Favorite>) request.getAttribute("myFavorites");
        if (myFavorites != null && !myFavorites.isEmpty()) {
            for (Favorite fav : myFavorites) {
        %>
            <div class="col-md-4 mb-3">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title">Cheatsheet #<%= fav.getCheatsheetId() %></h5>
                        <p class="card-text text-muted small">
                            <i class="fa-regular fa-clock"></i> Saved on: <%= fav.getCreatedAt() %>
                        </p>
                        <a href="<%= request.getContextPath() %>/cheatsheet-detail?id=<%= fav.getCheatsheetId() %>" class="btn btn-sm btn-primary">
                            <i class="fa-regular fa-eye"></i> View Detail
                        </a>
                    </div>
                </div>
            </div>
        <%
            }
        } else {
        %>
            <div class="col-12 text-center py-5">
                <i class="fa-regular fa-folder-open fa-3x text-muted mb-3"></i>
                <p class="text-muted">You haven't saved any cheatsheets yet.</p>
            </div>
        <%
        }
        %>
    </div>
</div>

</body>
</html>