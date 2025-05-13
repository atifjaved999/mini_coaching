
import DashboardLayout from "@/components/dashboard/DashboardLayout";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Calendar, Clock, Plus, User } from "lucide-react";

const Dashboard = () => {
  // Mock data for dashboard
  const upcomingSessions = [
    {
      id: 1,
      title: "Career Development Session",
      date: "May 15, 2025",
      time: "10:00 AM - 11:00 AM",
      client: "Alice Smith"
    },
    {
      id: 2,
      title: "Leadership Coaching",
      date: "May 16, 2025",
      time: "2:00 PM - 3:30 PM",
      client: "Bob Johnson"
    },
    {
      id: 3,
      title: "Business Strategy",
      date: "May 18, 2025",
      time: "11:00 AM - 12:00 PM",
      client: "Carol Williams"
    }
  ];

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
          <Button>
            <Plus className="h-4 w-4 mr-2" />
            New Session
          </Button>
        </div>

        {/* Stats Overview */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <StatsCard
            title="Total Clients"
            value="24"
            icon={<User className="h-5 w-5" />}
            description="2 new this month"
            trend="up"
          />
          <StatsCard
            title="Upcoming Sessions"
            value="12"
            icon={<Calendar className="h-5 w-5" />}
            description="For the next 7 days"
            trend="neutral"
          />
          <StatsCard
            title="Session Hours"
            value="32.5"
            icon={<Clock className="h-5 w-5" />}
            description="This month"
            trend="up"
          />
        </div>

        {/* Recent Sessions */}
        <Card>
          <CardHeader>
            <CardTitle>Upcoming Sessions</CardTitle>
            <CardDescription>
              Your scheduled coaching sessions for the coming days
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {upcomingSessions.map((session) => (
                <div
                  key={session.id}
                  className="flex items-center justify-between p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors"
                >
                  <div>
                    <h3 className="font-medium">{session.title}</h3>
                    <p className="text-sm text-gray-600">with {session.client}</p>
                  </div>
                  <div className="text-right">
                    <p className="font-medium">{session.date}</p>
                    <p className="text-sm text-gray-600">{session.time}</p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  );
};

interface StatsCardProps {
  title: string;
  value: string;
  icon: React.ReactNode;
  description: string;
  trend: "up" | "down" | "neutral";
}

const StatsCard = ({ title, value, icon, description, trend }: StatsCardProps) => {
  return (
    <Card>
      <CardContent className="p-6">
        <div className="flex items-center justify-between mb-4">
          <span className="text-gray-500">{title}</span>
          <span className="p-2 bg-primary/10 rounded-full text-primary">
            {icon}
          </span>
        </div>
        <div className="space-y-1">
          <h3 className="text-3xl font-bold">{value}</h3>
          <div className="flex items-center">
            {trend === "up" && (
              <span className="text-green-500 text-xs mr-1">↑ 12%</span>
            )}
            {trend === "down" && (
              <span className="text-red-500 text-xs mr-1">↓ 5%</span>
            )}
            <span className="text-gray-500 text-xs">{description}</span>
          </div>
        </div>
      </CardContent>
    </Card>
  );
};

export default Dashboard;
