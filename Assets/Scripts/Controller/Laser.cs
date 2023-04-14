using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Laser : MonoBehaviour
{
    /// <summary>
    /// This class handles the trigger of laser and samples. 
    /// </summary>
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("sample"))
        {
            Debug.Log("sample trigger");
            CollectHandler.s.isCollecting = true;
            CollectHandler.s.StartDissolveSample(other.gameObject);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("sample"))
        {
            Debug.Log("sample trigger exit");
            CollectHandler.s.isCollecting = false;
        }
    }
}
