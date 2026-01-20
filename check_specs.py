import subprocess

def get_specs():
    print("Checking system specifications...")
    print("-" * 30)

    # Check Memory (RAM)
    try:
        mem_bytes = subprocess.check_output(["sysctl", "hw.memsize"]).decode().split(":")[1].strip()
        mem_gb = int(mem_bytes) / (1024**3)
        print(f"Total Memory: {mem_gb:.2f} GB")
    except Exception as e:
        print(f"Could not retrieve memory info: {e}")

    print("-" * 30)

    # Check GPU Information
    try:
        gpu_info = subprocess.check_output(["system_profiler", "SPDisplaysDataType"]).decode()
        # Filter for relevant lines to keep output clean
        lines = gpu_info.split('\n')
        for line in lines:
            if "Chipset Model" in line or "VRAM" in line or "Vendor" in line:
                print(line.strip())
    except Exception as e:
        print(f"Could not retrieve GPU info: {e}")

if __name__ == "__main__":
    get_specs()
