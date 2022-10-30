import { FC, useEffect, useState } from "react";
import { FaSatelliteDish } from "react-icons/fa";
import { useNavigate } from "react-router-dom";
import AppTemplate, { AppHeader } from "../../components/AppTemplate";
import FlightModeActive from "../../components/FlightModeActive";
import { post } from "../../lib/post";
import { useCore } from "../../providers/CoreProvider";

const SDispatch = () => {
  const { flightMode } = useCore();
  const [jobs, setJobs] = useState([]);

  if (flightMode) return <FlightModeActive />;

  useEffect(() => {
    post("getJobs").then((data: any) => {
      setJobs(data);
    });
  }, []);

  return (
    <AppTemplate className="px-5 py-10">
      <AppHeader>Dispatch</AppHeader>

      <div id="dis" className="flex flex-col gap-3 max-h-[530px] overflow-auto">
        {jobs.map(function (job: any, index: any) {
          return (
            <Dispatch
              key={index}
              id={index}
              name={job.name}
              label={job.label}
              color={job.color}
            />
          );
        })}
      </div>
    </AppTemplate>
  );
};

interface IDispatch {
  id: number;
  name: string;
  label: string;
  color: string;
}

const Dispatch: FC<IDispatch> = ({ name, label, color }) => {
  const navigate = useNavigate();

  const handleFormSubmit = (e: any) => {
    e.preventDefault();

    post("sendDispatch", {
      job: name,
      message: e.target.message.value,
    }).then();

    navigate("/");
  };

  return (
    <div className="flex flex-col gap-1 justify-center items-center">
      <div>{label}</div>
      <form className="flex gap-1" onSubmit={handleFormSubmit}>
        <input
          className="w-full rounded-sm !bg-opacity-5 bg-black dark:bg-white p-1 text-zinc-900 dark:text-white px-2 dark:placeholder:text-white placeholder:!text-opacity-30 focus:ring-2 focus:bg-opacity-10 hover:bg-opacity-10 transition-all ring-blue-400 outline-none font-medium"
          name="message"
          required
          placeholder={"Type your emergency..."}
        />
        <button type="submit" className="btn !w-fit !rounded-sm">
          <FaSatelliteDish style={{ color: color }} />
        </button>
      </form>
    </div>
  );
};

export default SDispatch;
