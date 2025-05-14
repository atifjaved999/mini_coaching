import { useEffect, useState } from "react";
import DashboardLayout from "@/components/dashboard/DashboardLayout";
import { Button } from "@/components/ui/button";
import { useSelector } from "react-redux";
import { selectCurrentUser } from "@/slices/authSlice";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Calendar as CalendarIcon, Edit, Plus, Trash } from "lucide-react";
import { Calendar } from "@/components/ui/calendar";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { format } from "date-fns";
import { cn } from "@/lib/utils";
import { toast, useToast } from "@/hooks/use-toast";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import api from "@/lib/axios"; // Your Axios instance
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

// Form schema for session creation/editing
const sessionSchema = z.object({
  title: z.string().min(3, "Title must be at least 3 characters"),
  description: z.string(),
  date: z.date(),
  startTime: z
    .string()
    .regex(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/, "Must be in format HH:MM"),
  endTime: z
    .string()
    .regex(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/, "Must be in format HH:MM"),
});

// Schema
const bookingSchema = z.object({
  userId: z.string().min(1, "User is required"),
  date: z.date({ required_error: "Date is required" }),
});
type BookingFormValues = z.infer<typeof bookingSchema>;

type SessionFormValues = z.infer<typeof sessionSchema>;

// Mock session data
interface Session {
  id: string;
  title: string;
  description: string;
  date: Date;
  startTime: string;
  endTime: string;
  status: "upcoming" | "completed" | "cancelled";
}

const initialSessions: Session[] = [
  {
    id: "1",
    title: "Career Development Planning",
    description: "Setting 3-month goals and creating action plan.",
    date: new Date(2025, 4, 15),
    startTime: "10:00",
    endTime: "11:00",
    status: "upcoming",
  },
  {
    id: "2",
    title: "Leadership Skills Assessment",
    description:
      "Review of leadership assessment results and planning next steps.",
    date: new Date(2025, 4, 16),
    startTime: "14:00",
    endTime: "15:30",
    status: "upcoming",
  },
  {
    id: "3",
    title: "Communication Workshop",
    description: "Focus on improving team communication strategies.",
    date: new Date(2025, 4, 10),
    startTime: "11:00",
    endTime: "12:00",
    status: "completed",
  },
];

const SessionManagement = () => {
  const [sessions, setSessions] = useState<Session[]>([]);
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [selectedSession, setSelectedSession] = useState<Session | null>(null);
  const { toast } = useToast();
  const [isBooking, setIsBooking] = useState(false);
  const [users, setUsers] = useState([]);
  const user = useSelector(selectCurrentUser);

  useEffect(() => {
    const fetchSessions = async () => {
      try {
        let response;
        if (user.roles[0] === "client") {
          response = await api.get("/client_sessions");
        } else {
          response = await api.get("/coach_sessions");
        }
        const fetchedSessions = response.data.map((session) => ({
          id: session.id.toString(),
          title: session.title,
          description: session.description,
          date: new Date(session.scheduled_at),
          startTime: new Date(session.start_time).toTimeString().slice(0, 5),
          endTime: new Date(session.end_time).toTimeString().slice(0, 5),
          status: "upcoming", // Add logic if API provides status
        }));

        setSessions(fetchedSessions);
      } catch (err) {
        toast({
          title: "Error loading sessions",
          description: "Could not fetch sessions from the server.",
          variant: "destructive",
        });
      }
    };

    fetchSessions();
  }, []);

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const response = await api.get("/users");
        setUsers(response.data.filter((user) => user.roles.includes("coach")));
      } catch (error) {
        console.error("Failed to fetch users:", error);
      }
    };

    fetchUsers();
  }, []);
  const form = useForm<SessionFormValues>({
    resolver: zodResolver(sessionSchema),
    defaultValues: {
      title: "",
      description: "",
      date: new Date(),
      startTime: "09:00",
      endTime: "10:00",
    },
  });
  const form1 = useForm<BookingFormValues>({
    resolver: zodResolver(bookingSchema),
    defaultValues: {
      userId: "",
      date: undefined,
    },
  });

  const handleOpenDialog = (session: Session | null = null) => {
    setSelectedSession(session);

    if (session) {
      form.reset({
        title: session.title,
        description: session.description,
        date: session.date,
        startTime: session.startTime,
        endTime: session.endTime,
      });
    } else {
      form.reset({
        title: "",
        description: "",
        date: new Date(),
        startTime: "09:00",
        endTime: "10:00",
      });
    }

    setIsDialogOpen(true);
  };

  const handleSubmit = async (values: SessionFormValues) => {
    try {
      if (selectedSession) {
        // Optionally implement update API here
      } else {
        const response = await api.post("/sessions", {
          title: values.title,
          description: values.description,
          scheduled_at: values.date.toISOString().split("T")[0],
          start_time: `${values.date.toISOString().split("T")[0]}T${
            values.startTime
          }:00`,
          end_time: `${values.date.toISOString().split("T")[0]}T${
            values.endTime
          }:00`,
        });

        const newSession: Session = {
          id: response.data.id.toString(),
          title: response.data.title,
          description: response.data.description,
          date: new Date(response.data.scheduled_at),
          startTime: new Date(response.data.start_time)
            .toTimeString()
            .slice(0, 5),
          endTime: new Date(response.data.end_time).toTimeString().slice(0, 5),
          status: "upcoming", // Update if your API returns status
        };

        setSessions([...sessions, newSession]);
        toast({
          title: "Session created",
          description: "Your new coaching session has been scheduled.",
        });
      }

      setIsDialogOpen(false);
    } catch (error) {
      toast({
        title: "Error creating session",
        description: "Something went wrong while saving the session.",
        variant: "destructive",
      });
    }
  };

  const handleDelete = async (id: string) => {
    try {
      const res = await api.delete(`sessions/${id}`);

      // If deletion is successful, remove from state
      setSessions((prev) => prev.filter((session) => session.id !== id));

      toast({
        title: "Session Deleted",
        description: "The session has been removed from your calendar.",
      });
    } catch (error) {
      console.error("Delete error:", error.response.data);

      toast({
        title: "Failed to delete session",
        description: `${error.response.data.error}`,
        variant: "destructive",
      });
    }
  };

  const handleBook = () => {
    setIsBooking(true);
  };

  const submitBooking = async (data: BookingFormValues) => {
    try {
      await api.post("sessions/book", {
        coach_id: data.userId,
        scheduled_at: data.date.toISOString(),
      });

      toast({
        title: "Session booked successfully",
        description: `Scheduled on ${format(data.date, "PPP")}`,
      });

      setIsBooking(false);
      form.reset();
    } catch (error) {
      toast({
        title: "Booking failed",
        description: error.response?.data?.message || "Something went wrong.",
        variant: "destructive",
      });
    }
  };

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <h1 className="text-2xl font-bold text-gray-900">
            Session Management
          </h1>
          {user?.roles?.[0] === "client" ? (
            <Button onClick={() => handleBook()}>
              <Plus className="h-4 w-4 mr-2" />
              Book Session
            </Button>
          ) : (
            <Button onClick={() => handleOpenDialog()}>
              <Plus className="h-4 w-4 mr-2" />
              New Session
            </Button>
          )}
        </div>

        <div className="grid grid-cols-1 gap-4">
          <SessionList
            sessions={sessions}
            onEdit={handleOpenDialog}
            onDelete={handleDelete}
            handleBook={handleBook}
            role={user.roles[0]}
          />
        </div>
      </div>

      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent className="sm:max-w-[525px]">
          <DialogHeader>
            <DialogTitle>
              {selectedSession ? "Edit Session" : "Create New Session"}
            </DialogTitle>
            <DialogDescription>
              {selectedSession
                ? "Update the details of your coaching session."
                : "Fill in the details to schedule a new coaching session."}
            </DialogDescription>
          </DialogHeader>

          <Form {...form}>
            <form
              onSubmit={form.handleSubmit(handleSubmit)}
              className="space-y-4"
            >
              <FormField
                control={form.control}
                name="title"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Session Title</FormLabel>
                    <FormControl>
                      <Input placeholder="Career Coaching Session" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="description"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Description</FormLabel>
                    <FormControl>
                      <Textarea
                        placeholder="Brief description of the session..."
                        className="resize-none"
                        {...field}
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <div className="grid grid-cols-1 gap-4">
                <FormField
                  control={form.control}
                  name="date"
                  render={({ field }) => (
                    <FormItem className="flex flex-col">
                      <FormLabel>Date</FormLabel>
                      <Popover>
                        <PopoverTrigger asChild>
                          <FormControl>
                            <Button
                              variant={"outline"}
                              className={cn(
                                "w-full pl-3 text-left font-normal",
                                !field.value && "text-muted-foreground"
                              )}
                            >
                              {field.value ? (
                                format(field.value, "PPP")
                              ) : (
                                <span>Pick a date</span>
                              )}
                              <CalendarIcon className="ml-auto h-4 w-4 opacity-50" />
                            </Button>
                          </FormControl>
                        </PopoverTrigger>
                        <PopoverContent className="w-auto p-0" align="start">
                          <Calendar
                            mode="single"
                            selected={field.value}
                            onSelect={field.onChange}
                            disabled={(date) =>
                              date < new Date(new Date().setHours(0, 0, 0, 0))
                            }
                            initialFocus
                          />
                        </PopoverContent>
                      </Popover>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <FormField
                  control={form.control}
                  name="startTime"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Start Time</FormLabel>
                      <FormControl>
                        <Input type="time" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />

                <FormField
                  control={form.control}
                  name="endTime"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>End Time</FormLabel>
                      <FormControl>
                        <Input type="time" {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>

              <DialogFooter>
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => setIsDialogOpen(false)}
                >
                  Cancel
                </Button>
                <Button type="submit">
                  {selectedSession ? "Update Session" : "Create Session"}
                </Button>
              </DialogFooter>
            </form>
          </Form>
        </DialogContent>
      </Dialog>

      <Dialog open={isBooking} onOpenChange={setIsBooking}>
        <DialogContent className="sm:max-w-[525px]">
          <DialogHeader>
            <DialogTitle>Book Session</DialogTitle>
            <DialogDescription>
              Select a user and schedule the session
            </DialogDescription>
          </DialogHeader>

          <Form {...form1}>
            <form
              onSubmit={form1.handleSubmit(submitBooking)}
              className="space-y-4"
            >
              {/* userId dropdown */}
              <FormField
                control={form1.control}
                name="userId"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Select User</FormLabel>
                    <Select onValueChange={field.onChange} value={field.value}>
                      <FormControl>
                        <SelectTrigger>
                          <SelectValue placeholder="Select a user" />
                        </SelectTrigger>
                      </FormControl>
                      <SelectContent>
                        {users.map((user) => (
                          <SelectItem key={user.id} value={user.id.toString()}>
                            {user.name}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                    <FormMessage />
                  </FormItem>
                )}
              />

              {/* date picker */}
              <FormField
                control={form1.control}
                name="date"
                render={({ field }) => (
                  <FormItem className="flex flex-col">
                    <FormLabel>Session Date</FormLabel>
                    <Popover>
                      <PopoverTrigger asChild>
                        <FormControl>
                          <Button
                            variant="outline"
                            className={cn(
                              "w-full pl-3 text-left font-normal",
                              !field.value && "text-muted-foreground"
                            )}
                          >
                            {field.value
                              ? format(field.value, "PPP")
                              : "Pick a date"}
                            <CalendarIcon className="ml-auto h-4 w-4 opacity-50" />
                          </Button>
                        </FormControl>
                      </PopoverTrigger>
                      <PopoverContent className="w-auto p-0" align="start">
                        <Calendar
                          mode="single"
                          selected={field.value}
                          onSelect={field.onChange}
                          disabled={(date) =>
                            date < new Date(new Date().setHours(0, 0, 0, 0))
                          }
                          initialFocus
                        />
                      </PopoverContent>
                    </Popover>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <DialogFooter>
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => setIsBooking(false)}
                >
                  Cancel
                </Button>
                <Button type="submit">Confirm Booking</Button>
              </DialogFooter>
            </form>
          </Form>
        </DialogContent>
      </Dialog>
    </DashboardLayout>
  );
};

interface SessionListProps {
  sessions: Session[];
  onEdit: (session: Session) => void;
  handleBook: (session: Session) => void;
  onDelete: (id: string) => void;
  role: "";
}

const SessionList = ({
  sessions,
  onEdit,
  onDelete,
  handleBook,
  role,
}: SessionListProps) => {
  const user = useSelector(selectCurrentUser);

  // Filter and sort sessions: upcoming first, then completed
  const sortedSessions = [...sessions].sort((a, b) => {
    // First by status
    if (a.status === "upcoming" && b.status !== "upcoming") return -1;
    if (a.status !== "upcoming" && b.status === "upcoming") return 1;

    // Then by date
    return a.date.getTime() - b.date.getTime();
  });

  return (
    <div className="bg-white rounded-lg shadow overflow-hidden">
      <div className="p-4 bg-gray-50 border-b">
        <h3 className="font-medium">Your Coaching Sessions</h3>
      </div>

      {sortedSessions.length === 0 ? (
        <div className="p-8 text-center text-gray-500">
          <p>No sessions scheduled. Create a new session to get started.</p>
        </div>
      ) : (
        <ul>
          {sortedSessions.map((session) => (
            <li key={session.id} className="border-b last:border-b-0">
              <div className="p-4 hover:bg-gray-50 transition-colors flex items-center justify-between">
                <div className="flex items-center space-x-4">
                  <div
                    className={cn(
                      "w-3 h-3 rounded-full",
                      session.status === "upcoming"
                        ? "bg-green-500"
                        : session.status === "completed"
                        ? "bg-gray-400"
                        : "bg-red-500"
                    )}
                  />
                  <div>
                    <h4 className="font-medium">{session.title}</h4>
                    <p>{session.description}</p>
                    <p className="text-sm text-gray-600">
                      {format(session.date, "MMM dd, yyyy")} •{" "}
                      {session.startTime} - {session.endTime}
                    </p>
                  </div>
                </div>

                <div className="flex space-x-2">
                  {user?.roles?.[0] === "client" ? (
                    ""
                  ) : (
                    <Button
                      size="icon"
                      variant="ghost"
                      onClick={() => onDelete(session.id)}
                      className="h-8 w-8 text-red-500 hover:text-red-600 hover:bg-red-50"
                    >
                      <Trash className="h-4 w-4" />
                    </Button>
                  )}
                  {/* <Button 
        size="icon" 
        variant="ghost" 
        onClick={() => onEdit(session)}
        className="h-8 w-8"
      >
        <Edit className="h-4 w-4" />
      </Button> */}
                </div>
              </div>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

export default SessionManagement;
