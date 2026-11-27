import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { ROUTES } from "./config/routes";
import LoginView from "./views/auth/LoginView";
import DashboardView from "./views/dashboard/DashboardView";
import ProtectedRoute from "./views/common/ProtectedRoute";
import PanelLayout from "./views/layouts/PanelLayout";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Navigate to={ROUTES.LOGIN} replace />} />
        <Route path={ROUTES.LOGIN} element={<LoginView />} />
        <Route
          element={
            <ProtectedRoute>
              <PanelLayout />
            </ProtectedRoute>
          }
        >
          <Route path={ROUTES.DASHBOARD} element={<DashboardView />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
