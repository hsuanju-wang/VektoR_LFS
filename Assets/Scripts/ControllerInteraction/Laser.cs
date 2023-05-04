using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Laser : MonoBehaviour
{
    /// <summary>
    /// This class handles the trigger of laser and samples. 
    /// </summary>
    /// 

    public static Laser s;
    public Material hoverMaterial;
    public Material normalMaterial;
    private void Awake()
    {
        if (s != null && s != this)
        {
            Destroy(this);
        }
        else
        {
            s = this;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("sample"))
        {
            //Debug.Log("sample trigger");
            HoverOn();
            CollectHandler.s.isCollecting = true;
            CollectHandler.s.StartDissolveSample(other.gameObject);
        }
    }

    // Dont know the reason: this couldn't be triggered when sample disabled
    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("sample"))
        {
            Debug.Log("sample trigger exit");
            HoverOff();
            CollectHandler.s.isCollecting = false;
        }
    }


    public void LaserOn()
    {
        this.GetComponent<MeshRenderer>().enabled = true;
        this.GetComponent<CapsuleCollider>().enabled = true;
    }

    public void LaserOff()
    {
        this.GetComponent<MeshRenderer>().enabled = false;
        this.GetComponent<CapsuleCollider>().enabled = false;
    }

    public void HoverOff()
    {
        this.GetComponent<MeshRenderer>().material = normalMaterial;
    }

    public void HoverOn()
    {
        this.GetComponent<MeshRenderer>().material = hoverMaterial;
    }
}
