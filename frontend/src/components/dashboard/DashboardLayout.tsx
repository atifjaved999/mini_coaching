
import { ReactNode, useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import { Calendar, Home, MessageSquare, Settings, User } from "lucide-react";
import { useSelector } from "react-redux";
import {
  selectCurrentUser,
} from "@/slices/authSlice";
import { useDispatch } from "react-redux";
import { logout } from "@/slices/authSlice";
import { useNavigate } from "react-router-dom";

interface DashboardLayoutProps {
  children: ReactNode;
}

const DashboardLayout = ({ children }: DashboardLayoutProps) => {
  const [collapsed, setCollapsed] = useState(false);
  const user = useSelector(selectCurrentUser);
  const dispatch = useDispatch();
  const navigate = useNavigate();

  console.log(user);
  useEffect(()=>{
    console.log(user);

  },[user])

  const handleLogout = () => {
    dispatch(logout());        // clear auth data
    navigate("/login");        // redirect to login page
  };
  return (
    <div className="min-h-screen bg-gray-50 flex">
      {/* Sidebar */}
      <aside
        className={cn(
          "bg-white border-r border-gray-200 transition-all duration-300 ease-in-out",
          collapsed ? "w-20" : "w-64"
        )}
      >
        <div className="h-full flex flex-col">
          <div className="h-16 flex items-center justify-between px-4 border-b border-gray-200">
            <Link to="/" className={cn("flex items-center", collapsed && "justify-center")}>
              <span
                className={cn(
                  "text-xl font-bold bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent",
                  collapsed && "hidden"
                )}
              >
                CoachFlow
              </span>
              <span
                className={cn(
                  "hidden",
                  collapsed && "flex items-center justify-center w-10 h-10 rounded-full bg-primary text-white font-bold text-lg"
                )}
              >
                C
              </span>
            </Link>
            <Button
              variant="ghost"
              size="sm"
              onClick={() => setCollapsed(!collapsed)}
              className={cn("text-gray-500", collapsed && "mx-auto")}
            >
              {collapsed ? "→" : "←"}
            </Button>
          </div>

          <nav className="flex-1 py-6">
            <ul className="space-y-1 px-3">
              <NavItem
                to="/dashboard"
                icon={<Home className="h-5 w-5" />}
                label="Dashboard"
                collapsed={collapsed}
              />
              <NavItem
                to="/dashboard/sessions"
                icon={<Calendar className="h-5 w-5" />}
                label="Sessions"
                collapsed={collapsed}
              />
              {/* <NavItem
                to="/dashboard/messages"
                icon={<MessageSquare className="h-5 w-5" />}
                label="Messages"
                collapsed={collapsed}
              /> */}
              {/* <NavItem
                to="/dashboard/profile"
                icon={<User className="h-5 w-5" />}
                label="Profile"
                collapsed={collapsed}
              /> */}
              {/* <NavItem
                icon={<Settings className="h-5 w-5" />}
                label="Logout"
                collapsed={collapsed}
                onClick={handleLogout}
                role={button}
              /> */}
            </ul>
          </nav>
          <Button className="w-full" onClick={handleLogout}>Logout</Button>
          <div className="p-4 border-t border-gray-200">
            <div
              className={cn(
                "flex items-center",
                collapsed ? "justify-center" : "space-x-3"
              )}
            >
              <div className="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center">
                <User className="h-4 w-4 text-gray-500" />
              </div>
              {!collapsed && (
                <div>
                  <p className="text-sm font-medium">{user?.name}</p>
                  <p className="text-xs text-gray-500">{user?.email}</p>
                </div>
              )}
            </div>
          </div>
        </div>
      </aside>

      {/* Main content */}
      <main className="flex-1">
        <div className="py-6 px-8">{children}</div>
      </main>
    </div>
  );
};

interface NavItemProps {
  to: string;
  icon: ReactNode;
  label: string;
  collapsed: boolean;
}

const NavItem = ({ to, icon, label, collapsed }: NavItemProps) => {
  const isActive = window.location.pathname === to;

  return (
    <li>
      <Link
        to={to}
        className={cn(
          "flex items-center py-2 px-3 rounded-md transition-colors",
          isActive
            ? "bg-primary/10 text-primary"
            : "text-gray-600 hover:bg-gray-100",
          collapsed ? "justify-center" : "space-x-3"
        )}
      >
        {icon}
        {!collapsed && <span>{label}</span>}
      </Link>
    </li>
  );
};

export default DashboardLayout;
