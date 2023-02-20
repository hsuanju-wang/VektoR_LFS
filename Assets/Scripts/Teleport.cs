using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Teleport : MonoBehaviour
{
    public GameObject teleport;
    public float teleportHeight;
    public float speed;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    IEnumerator rise()
    {
        yield return new WaitForSeconds(0.5f); // voice over 

        while (Vector3.Distance(new Vector3(teleport.transform.position.x, teleportHeight, teleport.transform.position.z), teleport.transform.position) > 0.1f)
        {
            float step = speed * Time.deltaTime;
            teleport.transform.position += new Vector3(0f, speed * Time.deltaTime, 0f);
            // move sprite towards the target location
            yield return null;
        }
        
        SceneManager.LoadScene("Outside");
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("hand"))
        {
            StartCoroutine(rise());
            GetComponent<Collider>().enabled = false;
        }
    }
}
